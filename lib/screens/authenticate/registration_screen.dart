import 'package:course_registration/screens/main_page.dart';
import 'package:course_registration/service/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class RegistrationScreen extends StatefulWidget {
  static String id = 'registration_screen';
  final Function toggleView;

  RegistrationScreen({this.toggleView});

  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _formKey = GlobalKey<FormState>();
  final AuthService _authService = AuthService();
  String email, password, name, semester = "1";
  bool showProgress = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: showProgress
          ? Center(child: CircularProgressIndicator())
          : Form(
              key: _formKey,
              child: Column(
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
                  SizedBox(
                    height: 10,
                  ),
                  Card(
                    borderOnForeground: false,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        children: [
                          TextFormField(
                            keyboardType: TextInputType.name,
                            textAlign: TextAlign.center,
                            onChanged: (value) {
                              name = value;
                            },
                            validator: (val) =>
                                val.length < 0 ? 'Enter a name' : null,
                            decoration: InputDecoration(
                              hintText: 'Enter your name',
                            ),
                          ),
                          TextFormField(
                            keyboardType: TextInputType.emailAddress,
                            textAlign: TextAlign.center,
                            validator: (val) =>
                                val.isEmpty ? 'Please enter an email' : null,
                            onChanged: (value) {
                              email = value;
                            },
                            decoration: InputDecoration(
                              hintText: 'Enter your email',
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          TextFormField(
                            obscureText: true,
                            keyboardType: TextInputType.visiblePassword,
                            textAlign: TextAlign.center,
                            onChanged: (value) {
                              password = value;
                            },
                            validator: (val) => val.length < 6
                                ? 'Enter a password 6+ char long'
                                : null,
                            decoration: InputDecoration(
                              hintText: 'Enter your password',
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text('Choose your semester:'),
                          DropdownButton<String>(
                            value: semester,
                            icon: Icon(Icons.arrow_downward),
                            iconSize: 24,
                            elevation: 16,
                            onChanged: (String newValue) {
                              setState(() {
                                semester = newValue;
                              });
                            },
                            items: <String>[
                              '1',
                              '2',
                              '3',
                              '4',
                              '5',
                              '6',
                              '7',
                              '8'
                            ].map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                          ),
                        ],
                      ),
                    ),
                  ),
                  TextButton(
                    // style: ,S
                    // color: Colors.blueAccent,
                    child: Card(
                      color: Colors.lightBlue,
                      child: Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Text(
                          'Register',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                    onPressed: () async {
                      try {
                        if (_formKey.currentState.validate()) {
                          setState(() {
                            showProgress = true;
                          });
                          UserCredential newUser =
                              await _authService.registerWithEmailAndPassword(
                                  email, password, name, semester);

                          if (newUser != null) {
                            setState(() {
                              showProgress = false;
                            });

                            Navigator.of(context).pushNamed(MainPage.id);
                          }
                        }
                      } catch (e) {
                        print(e);
                      }
                    },
                  ),
                  TextButton(
                    onPressed: () {
                      widget.toggleView();
                    },
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Text(
                          'Login',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      color: Colors.lightBlue,
                    ),
                  )
                ],
              ),
            ),
    );
  }
}
