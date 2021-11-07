import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:course_registration/models/requests.dart';

class DatabaseService {
  final String uid;

  DatabaseService({this.uid});
  String tutorName;
  int no_of_leaves, no_of_leaves_this_month;
  int totalNoOfWorkingDays, totalNoOfWorkingDaysInMonth;

  //collection reference
  final CollectionReference remainderCollection =
      FirebaseFirestore.instance.collection('remainders');

  Future getStudent({String uid}) async {
    String userName;
    await FirebaseFirestore.instance
        .collection('studentList')
        .doc(uid)
        .get()
        .then((value) => {userName = value.data()['name']});
    return userName;
  }

  Future getSemester({String uid}) async {
    String semester;
    await FirebaseFirestore.instance
        .collection('studentList')
        .doc(uid)
        .get()
        .then((value) => {semester = value.data()['semester']});
    return semester;
  }

  Future<String> getTutorFromRollNo({String trimmedUid}) async {
    await FirebaseFirestore.instance
        .collection('studentList')
        .doc(trimmedUid)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        print(documentSnapshot['tutor'] + "lllllllllllllllll");
        tutorName = documentSnapshot['tutor'];
      }
    });
  }

  Future<int> getNoOfRollNoFromRollNo({String trimmedUid}) async {
    await FirebaseFirestore.instance
        .collection('studentList')
        .doc(trimmedUid)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        no_of_leaves = documentSnapshot['no_of_leaves'];
        no_of_leaves_this_month = documentSnapshot['no_of_leaves_this_month'];
      }
    });
  }

  Future getTotalNoOfWorkingDays() async {
    await FirebaseFirestore.instance
        .collection('semesterInfo')
        .doc("info")
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        totalNoOfWorkingDays = documentSnapshot['noOfWorkingDays'];
      }
    });
  }

  Future getTotalNoOfWorkingDaysInMonth() async {
    print("getting total no of working days in month");
    await FirebaseFirestore.instance
        .collection('semesterInfo')
        .doc("monthInfo")
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        totalNoOfWorkingDaysInMonth = documentSnapshot['noOfWorkingDays'];
      }
    });
  }

  Future incrementLeave({String trimmedUid, int noOfDays}) async {
    no_of_leaves += noOfDays;
    no_of_leaves_this_month += noOfDays;
    await FirebaseFirestore.instance
        .collection('studentList')
        .doc(trimmedUid)
        .update({
          'no_of_leaves': no_of_leaves,
          'no_of_leaves_this_month': no_of_leaves_this_month
        })
        .then((value) => print("Leave incremented"))
        .catchError((error) => print("Failed to increment leave"));
  }

  Future updateAttendancePercentages(
      {String trimmedUid, String semPer, String monPer}) async {
    await FirebaseFirestore.instance
        .collection('studentList')
        .doc(trimmedUid)
        .update({'monPercentage': monPer, 'semPercentage': semPer})
        .then((value) => print("Percentage updated"))
        .catchError((error) => print("Failed to update percentage"));
  }

  Future<List<Request>> getPresentRequests({String rollNo}) async {
    print("im in database.dart getPresentRequests func");
    List<Request> presentRequests = [];
    await getTutorFromRollNo(trimmedUid: rollNo);

    await FirebaseFirestore.instance
        .collection('studentData')
        .where('studentID', isEqualTo: rollNo)
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        print("hi");
        presentRequests.add(Request(
            noOfDays: doc['noOfDays'],
            topic: doc['topic'],
            startDay: doc['startDate'].toDate(),
            reason: doc['reason']));
      });
    });
    // print(presentRequests);
    return presentRequests;
  }

  Future addLeaveRequests(
      {String trimmedUid,
      String topic,
      String reason,
      int noOfDays,
      DateTime startDate}) async {
    print('Ill send $topic and $reason to firebase $trimmedUid');
    String tutor = await getTutorFromRollNo(trimmedUid: trimmedUid);
    int leaves = await getNoOfRollNoFromRollNo(trimmedUid: trimmedUid);
    incrementLeave(trimmedUid: trimmedUid, noOfDays: noOfDays);
    //calculate percentages and update on firebase
    String name = await getStudent(uid: trimmedUid);

    await getTotalNoOfWorkingDaysInMonth();
    await getTotalNoOfWorkingDays();

    double semesterAttendance = (((totalNoOfWorkingDays - noOfDays) * 100) /
        totalNoOfWorkingDays) as double;
    double monthlyAttendance =
        (((totalNoOfWorkingDaysInMonth - noOfDays) * 100) /
            totalNoOfWorkingDaysInMonth) as double;
    String monAttendanceStr = monthlyAttendance.toStringAsFixed(2);
    String semAttendanceStr = semesterAttendance.toStringAsFixed(2);

    await updateAttendancePercentages(
        trimmedUid: trimmedUid,
        monPer: monAttendanceStr,
        semPer: semAttendanceStr);

    print("monthly attendance: $monAttendanceStr");
    print("sem attendance: $semAttendanceStr");

    return await FirebaseFirestore.instance
        .collection('studentData')
        .add({
          'topic': topic,
          'reason': reason,
          'noOfDays': noOfDays,
          'startDate': startDate,
          'studentID': trimmedUid,
          'status': 0,
          'tutor': tutorName,
          'name': name,
        })
        .then((value) => print("Request Added"))
        .catchError((error) => print("Failed to add request: $topic"));
  }

  Future updateUserData(List routine, String title, String time) async {
    print(title);
    print(time);
    routine.add({
      'title': title,
      'time': time,
    });

    return await remainderCollection.doc(uid).update({
      'remainders': routine,
    });
  }

  Future referRemainders() async {
    return await remainderCollection.doc(uid).update({
      'remainders': [],
    });
  }

  Future deleteRemainder(List routine, int index) async {
    routine.removeAt(index);
    return await remainderCollection.doc(uid).update({
      'remainders': routine,
    });
  }

  //mapping the document snapshot into array of individual remainder lists
  List<dynamic> _mapFromSnapshot(DocumentSnapshot documentSnapshot) {
    return documentSnapshot.get('remainders');
  }

  //getting remainder stream
  Stream<List<dynamic>> get remainders {
    return remainderCollection.doc(uid).snapshots().map(_mapFromSnapshot);
  }
}
