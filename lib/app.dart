import 'package:flutter/material.dart';
import 'package:task_manager_project/ui/screens/email_validation_screen.dart';
import 'package:task_manager_project/ui/screens/main_nav_bar_holder.dart';
import 'package:task_manager_project/ui/screens/new_task_screen.dart';
import 'package:task_manager_project/ui/screens/pin_verification_screen.dart';
import 'package:task_manager_project/ui/screens/set_password_screen.dart';

import 'package:task_manager_project/ui/screens/sign_in.dart';
import 'package:task_manager_project/ui/screens/sign_up_screen.dart';

import 'package:task_manager_project/ui/screens/splash_screen.dart';
import 'package:task_manager_project/ui/screens/update_profile.dart';

class TaskManagerApplication extends StatelessWidget {
  const TaskManagerApplication({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        colorSchemeSeed: Colors.green,
        textTheme: TextTheme(
          titleLarge: TextStyle(fontSize: 28, fontWeight: FontWeight.w700),
        ),
        inputDecorationTheme: InputDecorationTheme(
          fillColor: Colors.white,
          filled: true,
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),

          hintStyle: TextStyle(color: Colors.grey),
          errorBorder: OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.circular(10),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.circular(10),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            fixedSize: Size.fromWidth(double.maxFinite),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            padding: EdgeInsets.symmetric(vertical: 12),
            backgroundColor: Colors.green,
            foregroundColor: Colors.white,
          ),
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(foregroundColor: Colors.grey),
        ),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => SplashScreen(),
        SignIn.name: (context) => SignIn(),
        SignUpScreen.name: (context) => SignUpScreen(),
        EmailValidationScreen.name: (context) => EmailValidationScreen(),
        PinVerificationScreen.name: (context) => PinVerificationScreen(),
        SetPasswordScreen.name: (context) => SetPasswordScreen(),
        MainNavBarHolder.name: (context) => MainNavBarHolder(),
        NewTaskScreen.name: (context) => NewTaskScreen(),
        UpdateProfile.name: (context) => UpdateProfile()
      },
    );
  }
}
