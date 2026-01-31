import 'package:e_commerce/Auth/screen/auth_login_signout.dart/auth_screen.dart';
import 'package:flutter/material.dart';

void main(List<String> args) {
  runApp(
    MyApp(),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
              seedColor: Colors.teal, brightness: Brightness.light),
          appBarTheme: AppBarTheme(
              backgroundColor: Colors.teal, foregroundColor: Colors.white),
          elevatedButtonTheme: ElevatedButtonThemeData(
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10))))),
      home: AuthScreen(),
    );
  }
}
