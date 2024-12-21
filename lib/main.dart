import 'package:flutter/material.dart';
import 'package:finalproject/login_signup_page.dart';
import 'package:finalproject/home_page.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomePage(),
    );
  }
}
