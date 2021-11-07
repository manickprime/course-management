import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:course_registration/models/requests.dart';
import 'package:course_registration/models/student.dart';
import 'package:course_registration/screens/profile.dart';
import 'package:course_registration/screens/show_requests.dart';
import 'package:course_registration/service/auth.dart';
import 'package:course_registration/service/database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CallerHomeStudent extends StatefulWidget {
  @override
  _CallerHomeStudentState createState() => _CallerHomeStudentState();
}

class _CallerHomeStudentState extends State<CallerHomeStudent> {
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  String leaveTopic, userName, leaveReason;
  DateTime selectedDate = DateTime.now();

  final leaveTopicController = TextEditingController();
  final leaveReasonController = TextEditingController();
  final noOfDaysController = TextEditingController();

  List<Request> presentRequests = [];

  Future<Null> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
      });
  }

  String tutorName;
  int semester = null;

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<Student>(context);
    // DatabaseService dbService = DatabaseService(uid: user.uid);
    String userUid = user.name;
    CollectionReference studentList =
        FirebaseFirestore.instance.collection('studentList');

    final String displayName = userUid.substring(0, userUid.length - 11);
    DatabaseService dbService = new DatabaseService(uid: user.uid);
    int noOfDays;

    return SafeArea(
      child: Scaffold(
          drawer: Drawer(
            child: Column(
              children: [
                SafeArea(
                  child: Column(
                    children: [
                      ListTile(
                        title: Text('Log Out'),
                        leading: Icon(Icons.arrow_back_ios),
                        onTap: () async {
                          await _auth.signOut();
                        },
                      ),
                      ListTile(
                        title: Text('Select course'),
                        leading: Icon(Icons.stream),
                        onTap: () {
                          setState(() {});
                          Navigator.push(
                              context,
                              new MaterialPageRoute(
                                  builder: (context) => new ShowRequests(
                                        semester: semester,
                                        rollNo: displayName,
                                      )));
                        },
                      ),
                      ListTile(
                        title: Text('Profile'),
                        leading: Icon(Icons.stream),
                        onTap: () {
                          setState(() {});
                          Navigator.push(
                              context,
                              new MaterialPageRoute(
                                  builder: (context) => new Profile(
                                        rollNo: displayName,
                                      )));
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          appBar: AppBar(
            title: Text('Course Selector'),
          ),
          body: SingleChildScrollView(
            child: SafeArea(
              child: Card(
                child: Form(
                  key: _formKey,
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              'Welcome,',
                              style: TextStyle(
                                fontSize: 18,
                              ),
                            ),
                            Text(
                              '$displayName!',
                              style: TextStyle(
                                fontSize: 18,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        FutureBuilder(
                          future: studentList.doc(displayName).get(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.done) {
                              print(userUid);
                              print(snapshot.data.data());
                              Map<String, dynamic> data =
                                  snapshot.data.data() as Map<String, dynamic>;
                              if (semester == null) {
                                semester = int.parse(data['semester']);
                              }

                              return Row(
                                children: [
                                  Text("Current semester : ",
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      )),
                                  Text("${data['semester']}",
                                      style: TextStyle(
                                        fontSize: 20,
                                      ))
                                ],
                              );
                            }

                            return Text("Loading",
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ));
                          },
                        ),
                        FutureBuilder(
                          future: studentList.doc(displayName).get(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.done) {
                              print(userUid);
                              print(snapshot.data.data());
                              Map<String, dynamic> data =
                                  snapshot.data.data() as Map<String, dynamic>;

                              return Row(
                                children: [
                                  Text("Current course : ",
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      )),
                                  Text("${data['currentCourse']}",
                                      style: TextStyle(
                                        fontSize: 20,
                                      ))
                                ],
                              );
                            }

                            return Text("Loading",
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ));
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          )),
    );
  }
}
