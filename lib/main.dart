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
import 'bloc/auth_bloc/auth_bloc.dart';
import './managers/auth_manger.dart';
import './login_signup_page.dart';
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
        BlocProvider(create: (context) => AuthBloc(auth: AuthManager()),),
      ], 
    child: MaterialApp(
      title: "Pakistan Law Library",
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // Custom Colors
        primaryColor: Color(0xFF002855), // Dark Blue (#002855)
        scaffoldBackgroundColor: Colors.white, // White background

        // AppBar Theme
        appBarTheme: AppBarTheme(
          backgroundColor: Color(0xFF002855), // Dark Blue AppBar
          foregroundColor: Colors.white, // White text/icons
          elevation: 2,
          titleTextStyle: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),

        // Button Theme
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Color(0xFF002855), // Dark Blue buttons
            foregroundColor: Colors.white, // White text/icons on buttons
            textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),

        // Text Theme
        textTheme: TextTheme(
          displayLarge: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: Color(0xFF002855), // Dark Blue for headers
          ),
          displayMedium: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Color(0xFF002855), // Dark Blue for subheaders
          ),
          bodyLarge: TextStyle(
            fontSize: 16,
            color: Colors.black, // Black for normal text
          ),
          bodyMedium: TextStyle(
            fontSize: 14,
            color: Colors.grey[800], // Grey for secondary text
          ),
        ),

        // Input Field Theme
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.grey[200], // Light grey for input fields
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Color(0xFF002855)), // Dark Blue border
            borderRadius: BorderRadius.circular(8),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey[400]!), // Light grey border
            borderRadius: BorderRadius.circular(8),
          ),
          hintStyle: TextStyle(color: Colors.grey[600]),
        ),

        // Bottom Navigation Bar Theme
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          backgroundColor: Colors.white, // White background
          selectedItemColor: Color(0xFF002855), // Dark Blue for selected items
          unselectedItemColor: Colors.grey, // Grey for unselected items
          selectedLabelStyle: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      initialRoute: '/login',
      routes: {
        '/login': (context) => LoginSignupPage(),
        '/home': (context) => HomePage(),
      },)
    );
  }
}
