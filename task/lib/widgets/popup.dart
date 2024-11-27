import 'package:flutter/material.dart';
import 'package:task/utils/colors.dart';
import 'package:task/utils/styles.dart';
import 'package:task/widgets/button.dart';

class MyPopUp extends StatelessWidget {
  final String message;
  final bool confirm;
  final BuildContext context;
  final VoidCallback? onConfirm;
  final bool isError;
  const MyPopUp(
      {super.key,
      required this.message,
      required this.context,
      this.confirm = false,
      this.isError = true,
      this.onConfirm});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: const EdgeInsets.all(0),
      backgroundColor: Colors.transparent,
      content: FittedBox(
        child: Container(
          height: 338,
          width: 547,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: MyColors.green,
            border: Border.all(color: MyColors.pink, width: 2),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 18),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(isError ? Icons.warning_rounded : Icons.check,
                  color: isError ? Colors.yellow : Colors.green, size: 80),
              const SizedBox(height: 22),
              Text(message,
                  style: MyTextStyles.medium,
                  maxLines: 2,
                  textAlign: TextAlign.center),
              const SizedBox(height: 55),
              createButtons()
            ],
          ),
        ),
      ),
    );
  }

  Widget createButtons() {
    if (confirm) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          myButton(() {
            Navigator.of(context).pop();
            if (onConfirm != null) {
              onConfirm!();
            }
          }, 'OK'),
          const SizedBox(width: 10),
          myButton(() {
            Navigator.of(context).pop();
          }, 'Cancel', transparent: true)
        ],
      );
    }
    return myButton(() {
      Navigator.of(context).pop();
      if (onConfirm != null) {
        onConfirm!();
      }
    }, 'OK');
  }
}
