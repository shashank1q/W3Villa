import 'package:flutter/material.dart';
import 'package:task/utils/colors.dart';

class MyConstants {
  static LinearGradient myGradient = const LinearGradient(
      colors: [MyColors.green, MyColors.black],
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter);

  static double gapBetweenTextfields = 20;
  static double gapBetween = 40;
  static String signupRoute = '/SignUp';
  static String loginRoute = '/login';
  static String dashborardRoute = '/Dashboard';

  static String success = "Success";
  static String apiUrl = "http://localhost:8000/";
}
