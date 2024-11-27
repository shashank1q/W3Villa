import 'package:flutter/material.dart';
import 'package:task/services/auth.dart';
import 'package:task/services/database.dart';
import 'package:task/utils/constants.dart';
import 'package:task/widgets/popup.dart';

class Dashboard extends StatelessWidget {
  const Dashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: isValid(),
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return const Scaffold(body: Center(child: Text('An error occurred')));
        }
        if (snapshot.data != MyConstants.success) {
          WidgetsBinding.instance.addPostFrameCallback((timeStamp) =>
              Navigator.of(context).pushNamedAndRemoveUntil(
                  MyConstants.loginRoute, (route) => false));
          return const SizedBox();
        }
        return FutureBuilder(
          future: getData(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return const Scaffold(
                  body: Center(child: Text('An error occurred')));
            }
            final tasks = snapshot.data as List<String>;
            return TaskList(tasks: tasks);
          },
        );
      },
    );
  }
}

class TaskList extends StatefulWidget {
  final List<String> tasks;
  const TaskList({super.key, required this.tasks});

  @override
  State<TaskList> createState() => _TaskListState();
}

class _TaskListState extends State<TaskList> {
  void _addTask() {
    showDialog(
      context: context,
      builder: (context) {
        final controller = TextEditingController();
        return AlertDialog(
          title: const Text('Add Task'),
          content: TextField(
            controller: controller,
            decoration: const InputDecoration(hintText: 'Enter your task'),
          ),
          actions: [
            TextButton(
              onPressed: () async {
                if (controller.text.isEmpty) {
                  return;
                }
                String msg = await addTask(controller.text);
                if (!context.mounted) return;
                if (msg != MyConstants.success) {
                  showDialog(
                    context: context,
                    builder: (context) =>
                        MyPopUp(message: msg, context: context),
                  );
                  return;
                }
                setState(() {
                  widget.tasks.add(controller.text);
                });
                Navigator.pop(context);
              },
              child: const Text('Add'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  void _editTask(int index) {
    showDialog(
      context: context,
      builder: (context) {
        final controller = TextEditingController(text: widget.tasks[index]);
        return AlertDialog(
          title: const Text('Edit Task'),
          content: TextField(
            controller: controller,
            decoration: const InputDecoration(hintText: 'Enter new task name'),
          ),
          actions: [
            TextButton(
              onPressed: () async {
                if (controller.text.isEmpty) {
                  return;
                }
                String msg = await editTask(index, controller.text);
                if (!context.mounted) return;
                if (msg != MyConstants.success) {
                  showDialog(
                    context: context,
                    builder: (context) =>
                        MyPopUp(message: msg, context: context),
                  );
                  return;
                }
                setState(() {
                  widget.tasks[index] = controller.text;
                  Navigator.pop(context);
                });
              },
              child: const Text('Save'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  void _deleteTask(int index) async {
    String msg = await deleteTask(index);
    if (!mounted) return;
    if (msg != MyConstants.success) {
      showDialog(
        context: context,
        builder: (context) => MyPopUp(message: msg, context: context),
      );
      return;
    }
    setState(() {
      widget.tasks.removeAt(index);
    });
  }

  void _logout() async {
    // Add logic for logging out here
    String msg = await signout();
    if (!mounted) return;
    if (msg != MyConstants.success) {
      showDialog(
        context: context,
        builder: (context) => MyPopUp(message: msg, context: context),
      );
      return;
    }
    Navigator.of(context)
        .pushNamedAndRemoveUntil(MyConstants.loginRoute, (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Task Dashboard'),
        centerTitle: true,
        actions: [
          Tooltip(
            message: 'Logout',
            child: IconButton(
              icon: const Icon(Icons.exit_to_app),
              onPressed: _logout,
            ),
          ),
        ],
      ),
      body: widget.tasks.isEmpty
          ? Center(
              child: Text(
                'No Task created',
                style: TextStyle(color: Colors.grey.shade800, fontSize: 30),
              ),
            )
          : ReorderableListView(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              buildDefaultDragHandles: false,
              onReorder: (oldIndex, newIndex) async {
                if (newIndex > oldIndex) newIndex--;
                final task = widget.tasks.removeAt(oldIndex);
                widget.tasks.insert(newIndex, task);
                setState(() {});
                String res = await reorderTasks(widget.tasks);
                if (!context.mounted) return;
                if (res != MyConstants.success) {
                  showDialog(
                    context: context,
                    builder: (context) =>
                        MyPopUp(message: res, context: context),
                  );
                  return;
                }
              },
              children: [
                for (int index = 0; index < widget.tasks.length; index++)
                  Card(
                    key: ValueKey(index),
                    child: ListTile(
                      leading: ReorderableDragStartListener(
                          index: index,
                          key: ValueKey(index),
                          child: const Icon(Icons.drag_handle)),
                      title: Text(widget.tasks[index],
                          overflow: TextOverflow.visible),
                      trailing: Wrap(
                        spacing: 8,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit, color: Colors.blue),
                            onPressed: () => _editTask(index),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () => _deleteTask(index),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addTask,
        child: const Icon(Icons.add),
      ),
    );
  }
}
