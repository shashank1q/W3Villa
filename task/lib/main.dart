import 'package:flutter/material.dart';
import 'package:task/pages/dashboard.dart';
import 'package:task/pages/login_ui.dart';
import 'package:task/pages/signup_ui.dart';
import 'package:task/utils/colors.dart';
import 'package:task/utils/constants.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'To-Do',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          primaryColor: MyColors.pink,
          brightness: Brightness.dark,
          fontFamily: 'Karla',
          scrollbarTheme: const ScrollbarThemeData(
            thumbVisibility: WidgetStatePropertyAll(true),
            thumbColor: WidgetStatePropertyAll(MyColors.whiteFaded),
          )),
      initialRoute: MyConstants.loginRoute,
      routes: {
        MyConstants.loginRoute: (context) => const LoginPage(),
        MyConstants.signupRoute: (context) => const SignupPage(),
        MyConstants.dashborardRoute: (context) => const Dashboard(),
      },
    );
  }
}
