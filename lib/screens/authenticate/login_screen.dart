import 'package:course_registration/screens/main_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  static String id = 'login_screen';
  final Function toggleView;

  LoginScreen({this.toggleView});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _auth = FirebaseAuth.instance;
  String email, password;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          SizedBox(
            height: 100,
          ),
          Text(
            'Leave Approval Student',
            style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: Colors.lightBlue),
          ),
          SizedBox(
            height: 100,
          ),
          Card(
            borderOnForeground: false,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  TextField(
                    onChanged: (value) {
                      email = value;
                    },
                    keyboardType: TextInputType.emailAddress,
                    textAlign: TextAlign.center,
                    decoration: InputDecoration(
                      hintText: 'Enter your email',
                    ),
                  ),
                  TextField(
                    onChanged: (value) {
                      password = value;
                    },
                    obscureText: true,
                    keyboardType: TextInputType.visiblePassword,
                    textAlign: TextAlign.center,
                    decoration: InputDecoration(
                      hintText: 'Enter your password',
                    ),
                  ),
                ],
              ),
            ),
          ),
          TextButton(
            onPressed: () async {
//              print(email + " " + password);
              try {
                final user = await _auth.signInWithEmailAndPassword(
                    email: email, password: password);
                if (user != null) {
                  Navigator.pushNamed(context, MainPage.id);
                }
              } catch (e) {
                print(e);
              }
            },
            child: Card(
                color: Colors.lightBlue,
                child: Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Text(
                    'Login',
                    style: TextStyle(color: Colors.white),
                  ),
                )),
            // color: Colors.blueAccent,
          ),
          TextButton(
            onPressed: () {
              widget.toggleView();
            },
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(5.0),
                child: Text(
                  'Register',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              color: Colors.lightBlue,
            ),
          )
        ],
      ),
    );
  }
}
