import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:course_registration/models/student.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // create our custom user object based on FirebaseUser
  Student _userFromFirebaseUser(User user) {
    return user != null ? Student(uid: user.uid, name: user.email) : null;
  }

  Stream<Student> get user {
    return _auth.authStateChanges().map(_userFromFirebaseUser);
  }

  //register with email and password
  Future registerWithEmailAndPassword(
      String email, String password, String name, String semester) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      User user = result.user;
      CollectionReference studentData =
          FirebaseFirestore.instance.collection("studentList");
      final String displayName = email.substring(0, email.length - 11);
      await studentData
          .doc(displayName)
          .set({'semester': semester, 'name': name, 'rollNo': displayName})
          .then((value) => print("Student document set"))
          .catchError(
              (error) => print("Failed to add user to firestore: $error"));
//      await DatabaseService(uid: user.uid)
//          .updateUserData([], 'first one', 'any possible time');
//           DatabaseService(uid: user.uid).referRemainders();

      return _userFromFirebaseUser(user);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  //signOut
  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
}
