import 'package:exam_practice/blocs/auth/auth_bloc.dart';
import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:exam_practice/blocs/auth/auth_event.dart';
import 'package:exam_practice/blocs/auth/auth_state.dart';
import 'auth.dart';


class LoginSignupPage extends StatefulWidget {
  @override
  _LoginSignupPageState createState() => _LoginSignupPageState();
}

class _LoginSignupPageState extends State<LoginSignupPage> {
  bool showSignup = false;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final Auth auth = Auth();
  final _authBloc = AuthBloc(auth: Auth());
//   Future<void> _signUp() async {
//   try {
//     await auth.createUserWithEmailAndPassword(
//       email: _emailController.text.trim(),
//       password: _passwordController.text.trim(),
//     );

    
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(content: Text("Sign Up Successful!")),
//     );
//   } on FirebaseAuthException catch (e) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(content: Text(e.message ?? "Sign Up Failed")),
//     );
//   }
// }

// Future<void> _login() async {
//   try {
//     await auth.signInWithEmailAndPassword(
//       email: _emailController.text.trim(),
//       password: _passwordController.text.trim(),
//     );
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(content: Text("Login Successful!")),
//     );
//   } on FirebaseAuthException catch (e) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(content: Text(e.message ?? "Login Failed")),
//     );
//   }
// }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
  body: BlocListener<AuthBloc,AuthState>(listener: (context,state){
    if (state is AuthLoggedIn){
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Already Logged In! (Thrown Listener)")),
      );
    }
  },
  child: Container(
    width: double.infinity,
    decoration: BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topCenter,
        colors: [
          Color(0xFF4BBEA1), // Top gradient color
          Color(0xFF3BA58B), // Middle gradient color
          Color(0xFF266958)  // Bottom gradient color
        ]
      )
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SizedBox(height: 80),
        Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              FadeInUp(
                duration: Duration(milliseconds: 1000),
                child: Text(
                  showSignup? "Sign Up" : "Log In",
                  style: TextStyle(color: Colors.white, fontSize: 40),
                ),
              ),
              SizedBox(height: 10),
              FadeInUp(
                duration: Duration(milliseconds: 1300),
                child: Text(
                  showSignup? "Create an Account":
                  "Welcome Back",
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 20),
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(60),
                topRight: Radius.circular(60)
              )
            ),
            child: Padding(
              padding: EdgeInsets.all(30),
              child: Column(
                children: <Widget>[
                  SizedBox(height: 60),
                  FadeInUp(
                    duration: Duration(milliseconds: 1400),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Color(0x804BBEA1), // Theme color with reduced opacity
                            blurRadius: 20,
                            offset: Offset(0, 10)
                          )
                        ]
                      ),
                      child: showSignup ? Column(
                        children: <Widget>[
                          Container(
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              border: Border(
                                bottom: BorderSide(color: Colors.grey.shade200)
                              )
                            ),
                            child: TextField(
                              controller: _emailController,
                              decoration: InputDecoration(
                                hintText: "Email",
                                hintStyle: TextStyle(color: Colors.grey),
                                border: InputBorder.none
                              ),
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              border: Border(
                                bottom: BorderSide(color: Colors.grey.shade200)
                              )
                            ),
                            child: TextField(
                              decoration: InputDecoration(
                                hintText: "Phone Number",
                                hintStyle: TextStyle(color: Colors.grey),
                                border: InputBorder.none
                              ),
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              border: Border(
                                bottom: BorderSide(color: Colors.grey.shade200)
                              )
                            ),
                            child: TextField(
                              obscureText: true,
                              controller: _passwordController,
                              decoration: InputDecoration(
                                hintText: "Password",
                                hintStyle: TextStyle(color: Colors.grey),
                                border: InputBorder.none
                              ),
                            ),
                          ),
                        ],
                      ) : Column(
                        children: <Widget>[
                          Container(
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              border: Border(
                                bottom: BorderSide(color: Colors.grey.shade200)
                              )
                            ),
                            child: TextField(
                              controller: _emailController,
                              decoration: InputDecoration(
                                hintText: "Email or Phone number",
                                hintStyle: TextStyle(color: Colors.grey),
                                border: InputBorder.none
                              ),
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              border: Border(
                                bottom: BorderSide(color: Colors.grey.shade200)
                              )
                            ),
                            child: TextField(
                              obscureText: true,
                              controller: _passwordController,
                              decoration: InputDecoration(
                                hintText: "Password",
                                hintStyle: TextStyle(color: Colors.grey),
                                border: InputBorder.none
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 30),
                  
                  showSignup ? 
                  Row(
                    children: <Widget>[
                      Text(
                      "Already have an account?",
                      style: TextStyle(color: Colors.grey),
                    ), GestureDetector(
                      onTap: () {
                        setState(() {
                          showSignup = !showSignup;
                        });
                      },
                      child: Text(" tap here to Log In", style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),) // Theme color with bold text
                    )
                    ],
                  ) :
                  Row(
                    children: <Widget>[
                      Text(
                      "Don't have an account?",
                      style: TextStyle(color: Colors.grey),
                    ), GestureDetector(
                      onTap: () {
                        setState(() {
                          showSignup = !showSignup;
                        });
                      },
                      child: Text(" tap here to Sign Up", style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),) // Theme color with bold text
                    )
                    ],
                  ),

                  SizedBox(height: 30),
                  FadeInUp(
                    duration: Duration(milliseconds: 1500),
                    child: Text(
                      "Forgot Password?",
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
                  SizedBox(height: 30),
                  FadeInUp(
                    duration: Duration(milliseconds: 1600),
                    child: MaterialButton(
                      onPressed: () async {
                        if (showSignup) {
                          context.read<AuthBloc>().add(
      AuthSignupEvent(email: _emailController.text, password: _passwordController.text),
    );
                        } else {
                          context.read<AuthBloc>().add(
      AuthLoginEvent(email: _emailController.text, password: _passwordController.text),
    );
                        }
                      },
                      height: 50,
                      color: Color(0xFF266958), // Button color from theme
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: Center(
                        child: Text(
                          showSignup? "Sign Up" : "Log In",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 30),
                  FadeInUp(
                    duration: Duration(milliseconds: 1700),
                    child: Text(
                      "Continue with social media",
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
                  SizedBox(height: 30),
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: FadeInUp(
                          duration: Duration(milliseconds: 1800),
                          child: MaterialButton(
                            onPressed: () {},
                            height: 50,
                            color: Colors.white, // Facebook button color remains blue
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset('assets/images/google_logo.png',height: 24,width: 24,),
                                SizedBox(width: 10),
                                Text(
                                "Google",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold
                                ),
                              ),
                              ],
                            ),                         
                          ),
                        ),
                      ),
                      // SizedBox(width: 30),
                      // Expanded(
                      //   child: FadeInUp(
                      //     duration: Duration(milliseconds: 1900),
                      //     child: MaterialButton(
                      //       onPressed: () {},
                      //       height: 50,
                      //       color: Colors.black, // GitHub button color remains black
                      //       shape: RoundedRectangleBorder(
                      //         borderRadius: BorderRadius.circular(50),
                      //       ),
                      //       child: Center(
                      //         child: Text(
                      //           "Github",
                      //           style: TextStyle(
                      //             color: Colors.white,
                      //             fontWeight: FontWeight.bold
                      //           ),
                      //         ),
                      //       ),
                      //     ),
                      //   ),
                      // )
                    ],
                  )
                ],
              ),
            ),
          ),
        )
      ],
    ),
  ),
));
  }
}