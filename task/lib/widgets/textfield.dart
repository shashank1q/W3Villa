import 'package:flutter/material.dart';
import 'package:task/utils/colors.dart';
import 'package:task/utils/styles.dart';

SizedBox myTextField(String label, TextEditingController controller,
    IconData? icon, double screenWidth,
    {bool isPassword = false, bool error = false, String errorText = ""}) {
  if (errorText == "") {
    errorText = "Invalid $label";
  }
  return SizedBox(
    // height: screenWidth < 450 ? 80 : 70,
    width: 545,
    child: TextField(
      controller: controller,
      obscureText: isPassword,
      style: MyTextStyles.medium,
      cursorColor: MyColors.pink,
      decoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(
              vertical: screenWidth < 450 ? 20 : 15, horizontal: 12),
          prefixIcon: icon != null ? Icon(icon, size: 30) : null,
          labelText: label,
          labelStyle: MyTextStyles.inputLabel,
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(width: 2, color: MyColors.pink),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(width: 2, color: MyColors.lightGrey),
          ),
          prefixIconColor: MyColors.pink),
    ),
  );
}
