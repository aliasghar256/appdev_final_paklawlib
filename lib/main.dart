import 'package:flutter/material.dart';
import 'package:finalproject/login_signup_page.dart';
import 'package:finalproject/home_page.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'bloc/judgment_bloc/judgment_bloc.dart';
import './managers/judgment_manager.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MultiBlocProvider(providers: [
        BlocProvider(create: (context) => JudgmentBloc(manager: JudgmentManager()),),
        
      ], 
      child: HomePage(),)
    );
  }
}
