import 'package:course_registration/models/student.dart';
import 'package:course_registration/screens/wrapper/wrapper.dart';
import 'package:course_registration/service/auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class WrapperHome extends StatelessWidget {
  static String id = 'wrapper';

  @override
  Widget build(BuildContext context) {
    return StreamProvider<Student>.value(
      value: AuthService().user,
      child: MaterialApp(
        home: Wrapper(),
      ),
    );
  }
}
