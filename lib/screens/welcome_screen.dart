import 'package:course_registration/screens/authenticate/login_screen.dart';
import 'package:course_registration/screens/authenticate/registration_screen.dart';
import 'package:flutter/material.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

class WelcomeScreen extends StatefulWidget {
  static String id = 'welcome_screen';

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
//        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Flexible(
            flex: 3,
            child: Hero(
              tag: 'logo',
              child: FlareActor(
                "assets/open.flr",
                alignment: Alignment.center,
                fit: BoxFit.contain,
                animation: "open",
              ),
            ),
          ),
          Flexible(
            flex: 1,
            child: ColorizeAnimatedTextKit(
              text: ["schoolApp"],
              textStyle: TextStyle(
                fontSize: 50,
                fontFamily: "Canterbury",
              ),
              colors: [
                Colors.purple,
                Colors.blue,
                Colors.yellow,
                Colors.red,
              ],
              textAlign: TextAlign.center,
              // alignment: AlignmentDirectional.topCenter,
            ),
          ),
          Flexible(
            child: TextButton(
              child: Text(
                'login',
              ),
              onPressed: () {
                print("go to login");
                Navigator.pushNamed(context, LoginScreen.id);
              },
              // color: Colors.blueAccent,
            ),
            flex: 1,
          ),
          Flexible(
            child: TextButton(
              child: Text(
                'register',
              ),
              // color: Colors.blueAccent,
              onPressed: () {
//                print("go to register");
                Navigator.pushNamed(context, RegistrationScreen.id);
              },
            ),
            flex: 1,
          ),
        ],
      ),
    );
  }
}
