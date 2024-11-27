import 'package:flutter/material.dart';
import 'package:task/services/auth.dart';
import 'package:task/utils/constants.dart';
import 'package:task/widgets/button.dart';
import 'package:task/widgets/popup.dart';
import 'package:task/widgets/textfield.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: const LoginPage(),
    theme: ThemeData(fontFamily: 'Poppins'),
  ));
}

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  String dropdowntext = '';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: BoxDecoration(gradient: MyConstants.myGradient),
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Center(
            child: FittedBox(
              child: Column(
                children: [
                  const SizedBox(height: 90),
                  const Text('TASK',
                      style: TextStyle(
                          fontSize: 50,
                          color: Colors.white,
                          fontWeight: FontWeight.bold)),
                  SizedBox(height: MyConstants.gapBetween),
                  myTextField('Enter E-mail ID', emailController,
                      Icons.email_rounded, MediaQuery.of(context).size.width),
                  SizedBox(height: MyConstants.gapBetweenTextfields),
                  myTextField('Enter Password', passwordController,
                      Icons.password_rounded, MediaQuery.of(context).size.width,
                      isPassword: true),
                  SizedBox(height: MyConstants.gapBetween),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      myButton(_onLogin, 'Login'),
                      const SizedBox(width: 10),
                      myButton(() {
                        Navigator.of(context)
                            .pushNamed(MyConstants.signupRoute);
                      }, 'Sign Up', transparent: true),
                    ],
                  ),
                  const SizedBox(height: 25)
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _onLogin() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
    // regx for email check
    final regExp = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!regExp.hasMatch(emailController.text)) {
      Navigator.of(context).pop();
      showDialog(
        context: context,
        builder: (context) {
          return MyPopUp(
              message: 'Please enter a valid email', context: context);
        },
      );
      return;
    }
    if (passwordController.text.length < 6) {
      Navigator.of(context).pop();
      showDialog(
        context: context,
        builder: (context) {
          return MyPopUp(
              message: 'Password length must be atleast 6 character',
              context: context);
        },
      );
      return;
    }
    signIn(emailController.text, passwordController.text).then(
      (res) {
        if (!mounted) return;
        Navigator.of(context).pop();
        if (MyConstants.success == res) {
          Navigator.of(context).pushNamedAndRemoveUntil(
              MyConstants.dashborardRoute, (route) => false);
        } else {
          showDialog(
            context: context,
            builder: (context) {
              return MyPopUp(message: res, context: context);
            },
          );
        }
      },
    ).onError((error, stackTrace) {
      if (!mounted) return;
      Navigator.of(context).pop();
      showDialog(
        context: context,
        builder: (context) {
          return MyPopUp(message: error.toString(), context: context);
        },
      );
    });
  }
}
