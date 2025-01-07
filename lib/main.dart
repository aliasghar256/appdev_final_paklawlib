import 'package:flutter/material.dart';
import 'package:finalproject/login_signup_page.dart';
import 'package:finalproject/home_page.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'bloc/judgment_bloc/judgment_bloc.dart';
import './managers/judgment_manager.dart';
import 'bloc/notifications_bloc/notifications_bloc.dart';
import 'view_judgment_page.dart';
import 'bloc/templates_bloc/templates_bloc.dart';
import './managers/templates_manager.dart';
import 'templates_screen.dart';
import './managers/notifications_manager.dart';
void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(providers: [
        BlocProvider(create: (context) => JudgmentBloc(manager: JudgmentManager()),),
        BlocProvider(create: (context) => NotificationsBloc(manager: NotificationsManager()),),
        BlocProvider(create: (context) => TemplatesBloc(manager: TemplatesManager()),),
      ], 
    child: MaterialApp(
      home: TemplatesScreen(),)
    );
  }
}
