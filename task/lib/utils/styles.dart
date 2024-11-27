import 'package:flutter/material.dart';
import 'package:task/utils/colors.dart';

class MyTextStyles {
  static TextStyle large =
      const TextStyle(fontSize: 20, fontWeight: FontWeight.bold);
  static TextStyle inputLabel = const TextStyle(
      fontSize: 18, fontWeight: FontWeight.normal, color: MyColors.whiteFaded);
  static TextStyle medium = const TextStyle(
      fontSize: 16, fontWeight: FontWeight.normal, color: MyColors.white);
  static TextStyle link = const TextStyle(
      fontSize: 16, fontWeight: FontWeight.normal, color: MyColors.teal);
  static TextStyle errorOrTask({bool isError = false}) {
    return TextStyle(
        fontSize: 15,
        fontWeight: isError ? FontWeight.normal : FontWeight.bold,
        color: isError ? MyColors.red : MyColors.white);
  }

  static TextStyle small(
      {bool forList = true,
      bool forError = false,
      bool strikethrough = false,
      double size = 750}) {
    if (forError) {
      return TextStyle(
          fontSize: size < 600 ? 11 : 15,
          fontWeight: FontWeight.normal,
          color: MyColors.red);
    }

    Color color = MyColors.white;
    if (strikethrough) {
      color = MyColors.lightGrey;
    } else if (forList) {
      color = MyColors.whiteFaded;
    }
    return TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.normal,
        color: color,
        decoration: strikethrough ? TextDecoration.lineThrough : null);
  }
}
