import 'package:course_registration/models/student.dart';
import 'package:course_registration/screens/authenticate/authenticate.dart';
import 'package:course_registration/service/database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../caller_home_student.dart';

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<Student>(context);
    DatabaseService dbService = new DatabaseService(uid: user.uid);

    if (user == null) {
      print("register");
      return Authenticate();
    } else {
      print("login");
      return CallerHomeStudent();
      // return MainPage();
    }
  }
}
