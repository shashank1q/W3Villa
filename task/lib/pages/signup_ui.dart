import 'package:flutter/material.dart';
import 'package:task/services/auth.dart';
import 'package:task/utils/colors.dart';
import 'package:task/utils/constants.dart';
import 'package:task/utils/styles.dart';
// import 'package:task/utils/user.dart';
import 'package:task/widgets/button.dart';
import 'package:task/widgets/popup.dart';
import 'package:task/widgets/textfield.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: BoxDecoration(gradient: MyConstants.myGradient),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(15),
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const FittedBox(child: SizedBox(height: 80, width: 600)),
                const FittedBox(
                  child: IntrinsicHeight(
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "TASK",
                            style: TextStyle(
                                color: MyColors.white,
                                fontSize: 50,
                                fontWeight: FontWeight.bold),
                          ),
                          SizedBox(width: 30),
                          VerticalDivider(
                            color: MyColors.teal,
                            thickness: 1,
                            width: 20,
                            indent: 15,
                            endIndent: 15,
                          ),
                          SizedBox(width: 30),
                          Text(
                            "Sign Up",
                            style: TextStyle(
                                color: MyColors.white,
                                fontSize: 50,
                                fontWeight: FontWeight.bold),
                          ),
                        ]),
                  ),
                ),
                FittedBox(
                    child:
                        SizedBox(height: MyConstants.gapBetween, width: 600)),
                FittedBox(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      myTextField(
                          'E-mail',
                          emailController,
                          Icons.email_rounded,
                          MediaQuery.of(context).size.width),
                      SizedBox(height: MyConstants.gapBetweenTextfields),
                      myTextField(
                          'Create Password',
                          passwordController,
                          Icons.password_rounded,
                          MediaQuery.of(context).size.width,
                          isPassword: true),
                      SizedBox(height: MyConstants.gapBetween),
                      myButton(_onSignup, 'Sign Up'),
                      SizedBox(height: MyConstants.gapBetweenTextfields),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text('Already have an account? ',
                              style: MyTextStyles.medium),
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: Text('Login', style: MyTextStyles.link),
                          )
                        ],
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _onSignup() async {
    // Loading
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
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
    signup(emailController.text, passwordController.text).then(
      (res) {
        if (!mounted) return;
        // loading end
        Navigator.of(context).pop();
        if (MyConstants.success != res) {
          showDialog(
            context: context,
            builder: (context) {
              return MyPopUp(message: res, context: context);
            },
          );
          return;
        }
        showDialog(
          context: context,
          builder: (context) {
            return MyPopUp(
              message: 'Account created successfully',
              isError: false,
              context: context,
              onConfirm: () {
                Navigator.of(context).pushNamedAndRemoveUntil(
                    MyConstants.loginRoute, (route) => false);
              },
            );
          },
        );
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
