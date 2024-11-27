import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:task/utils/constants.dart';

Future<List<String>> getData() async {
  try {
    String token = await SharedPreferencesAsync().getString('token') ?? '';
    final res = await Dio().get('${MyConstants.apiUrl}db/get',
        options: Options(headers: {'Authorization': 'Bearer $token'}));
    return List<String>.from(res.data);
  } catch (e) {
    rethrow;
  }
}

// reorder tasks in database
Future<String> reorderTasks(List<String> tasks) async {
  try {
    String token = await SharedPreferencesAsync().getString('token') ?? '';
    await Dio().put('${MyConstants.apiUrl}db/reorder',
        options: Options(
            contentType: Headers.jsonContentType,
            headers: {'Authorization': 'Bearer $token'}),
        data: {'data': tasks});
    return MyConstants.success;
  } catch (e) {
    return e.toString();
  }
}

// add task to database
Future<String> addTask(String task) async {
  try {
    String token = await SharedPreferencesAsync().getString('token') ?? '';
    await Dio().post('${MyConstants.apiUrl}db/add',
        options: Options(
            contentType: Headers.jsonContentType,
            headers: {'Authorization': 'Bearer $token'}),
        data: {'task': task});
    return MyConstants.success;
  } catch (e) {
    return e.toString();
  }
}

// edit task in database
Future<String> editTask(int index, String task) async {
  try {
    String token = await SharedPreferencesAsync().getString('token') ?? '';
    await Dio().patch('${MyConstants.apiUrl}db/edit',
        options: Options(
            contentType: Headers.jsonContentType,
            headers: {'Authorization': 'Bearer $token'}),
        data: {'index': index, 'task': task});
    return MyConstants.success;
  } catch (e) {
    return e.toString();
  }
}

// delete task from database
Future<String> deleteTask(int index) async {
  try {
    String token = await SharedPreferencesAsync().getString('token') ?? '';
    await Dio().delete('${MyConstants.apiUrl}db/delete',
        options: Options(
            contentType: Headers.jsonContentType,
            headers: {'Authorization': 'Bearer $token'}),
        data: {'index': index});
    return MyConstants.success;
  } catch (e) {
    return e.toString();
  }
}
