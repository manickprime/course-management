import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:course_registration/models/requests.dart';
import 'package:course_registration/service/database.dart';
import 'package:flutter/material.dart';

class ShowRequests extends StatefulWidget {
  static String id = 'welcome_screen';
  int semester;
  String rollNo;

  ShowRequests({this.semester, this.rollNo});

  @override
  _ShowRequestsState createState() => _ShowRequestsState();
}

class _ShowRequestsState extends State<ShowRequests> {
  List<Request> presentRequests = [];
  Future<List<Request>> _requestsList;
  static String userRollNo;
  int semester;
  DatabaseService dbService = new DatabaseService(uid: userRollNo);
  CollectionReference studentList =
      FirebaseFirestore.instance.collection('studentList');

  @override
  void initState() {
    semester = widget.semester;
    userRollNo = widget.rollNo;
    super.initState();
  }

  Future<List<Request>> getRequests() async {
    print("im in get requests function in show requests page");
    print(userRollNo);
    presentRequests = await dbService.getPresentRequests(rollNo: userRollNo);
    print("Received here");
    return presentRequests;
  }

  @override
  Widget build(BuildContext context) {
    CollectionReference studentData =
        FirebaseFirestore.instance.collection('courses');

    userRollNo = widget.rollNo;
    print("hello there");
    print(userRollNo);

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text("Course Selection"),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "Current chosen one:",
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            FutureBuilder(
              future: studentList.doc(userRollNo).get(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  print(userRollNo);
                  print("dum");
                  print(snapshot.data.data());
                  Map<String, dynamic> data =
                      snapshot.data.data() as Map<String, dynamic>;
                  if (snapshot.hasData)
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text("${data['currentCourse']}",
                          style: TextStyle(
                            fontSize: 20,
                          )),
                    );
                }

                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text("Loading....",
                      style: TextStyle(
                        fontSize: 20,
                      )),
                );
              },
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text("Available courses",
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  )),
            ),
            StreamBuilder<QuerySnapshot>(
              stream: studentData.where('sem', isEqualTo: semester).snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) {
                  return Center(child: Text('Something went wrong'));
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: Text('Loading'));
                }

                if (snapshot.data.docs.length == 0) {
                  return Center(child: Text('No requests to be reviewed'));
                }

                return ListView(
                  shrinkWrap: true,
                  children: snapshot.data.docs.map((DocumentSnapshot document) {
                    return GestureDetector(
                      child: Card(
                        borderOnForeground: true,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            '${document.get('courseName')}',
                            style: TextStyle(fontSize: 20),
                          ),
                        ),
                      ),
                      onTap: () {
                        CollectionReference students = FirebaseFirestore
                            .instance
                            .collection('studentList');

                        students
                            .doc(userRollNo)
                            .update({
                              'currentCourse': '${document.get('courseName')}'
                            })
                            .then((value) => print("Student course Updated"))
                            .catchError((error) => print(
                                "Failed to update student course: $error"));
                        setState(() {});

                        print(
                            "choose this course as current course ${document.get('courseName')}");
                      },
                    );
                  }).toList(),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
