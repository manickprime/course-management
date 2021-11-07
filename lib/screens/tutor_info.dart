import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class TutorInfo extends StatefulWidget {
  String rollNo, tutorName;

  TutorInfo({this.rollNo, this.tutorName});

  @override
  _TutorInfoState createState() => _TutorInfoState();
}

class _TutorInfoState extends State<TutorInfo> {
  CollectionReference tutorInfoReference =
      FirebaseFirestore.instance.collection('tutorInfo');

  String tutorName;

  @override
  void initState() {
    tutorName = widget.tutorName;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print(tutorName);

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Tutor Info'),
        ),
        body: FutureBuilder<DocumentSnapshot>(
          future: tutorInfoReference.doc(tutorName).get(),
          builder:
              (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
            if (snapshot.connectionState != ConnectionState.done) {
              return Text("loading");
            } else {
              if (snapshot.hasError) {
                return Text("Something went wrong");
              } else {
                if (snapshot.hasData) {
                  Map<String, dynamic> data = snapshot.data.data();
                  return Column(
                    children: [
                      Text('Name'),
                      Text(data['name']),
                      Text('Email'),
                      Text(data['email']),
                      Text('Phone'),
                      Text(data['phoneNo']),
                      Text('No of wards'),
                      Text('${data['noOfWards']}'),
                    ],
                  );
                } else {
                  return Text("No data");
                }
              }
            }
          },
        ),
      ),
    );
  }
}

// Text("Name: ${data['name']} \n Email: ${data['email']}")

// Center(
// child: Column(
// children: [
// Text('Name'),
// Text('Email id'),
// Text('Phone no'),
// Text('No of tutor wards'),
// TextButton(
// onPressed: () {
// print('fetching data from ${widget.rollNo}');
// },
// child: Text('Get tutor info')),
// ],
// )),
