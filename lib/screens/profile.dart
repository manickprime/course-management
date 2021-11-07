import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:course_registration/service/auth.dart';
import 'package:course_registration/service/database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Profile extends StatefulWidget {
  String rollNo;

  Profile({this.rollNo});

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final AuthService _auth = AuthService();
  final DatabaseService _dbService = DatabaseService();

  CollectionReference semesterData =
      FirebaseFirestore.instance.collection('semesterInfo');
  CollectionReference studentList =
      FirebaseFirestore.instance.collection('studentList');

  static String userRollNo;

  @override
  void initState() {
    userRollNo = widget.rollNo;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double leave, workingDays, attendancePercentage;

    return Scaffold(
      appBar: AppBar(
        title: Text("Student profile"),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    "Name    : ",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                  FutureBuilder(
                    future: studentList.doc(userRollNo).get(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.done) {
                        Map<String, dynamic> data =
                            snapshot.data.data() as Map<String, dynamic>;

                        return Text(
                          "${data['name']}",
                          style: TextStyle(fontSize: 20),
                        );
                        return Text(
                          "${data['name']}",
                          style: TextStyle(fontSize: 20),
                        );
                      }

                      return Text("loading");
                    },
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  Text(
                    "Roll No : ",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                  Text(
                    userRollNo,
                    style: TextStyle(fontSize: 20),
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                "Course history:",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: FutureBuilder(
                  future: studentList.doc(userRollNo).get(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      Map<String, dynamic> data =
                          snapshot.data.data() as Map<String, dynamic>;

                      List<Text> semCouses = [];
                      for (int i = 1; i <= 8; i++) {
                        print("sem $i: ${data['sem$i']}");
                        String nullString = "yet to be added";
                        if (data['sem$i'] != "")
                          semCouses.add(Text(
                            "Sem $i: ${data['sem$i']}",
                            style: TextStyle(fontSize: 20),
                          ));
                        else
                          semCouses.add(Text(
                            "Sem $i: ${data['sem$i']}$nullString",
                            style: TextStyle(fontSize: 20),
                          ));
                      }
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: semCouses,
                      );
                    }

                    return Text("Leave taken: loading");
                  },
                ),
              ),

              // Text(attendancePercentage == null ? "loading" : attendancePercentage),
            ],
          ),
        ),
      ),
    );
  }
}
