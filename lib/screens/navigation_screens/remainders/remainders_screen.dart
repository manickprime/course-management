import 'package:course_registration/models/student.dart';
import 'package:course_registration/screens/navigation_screens/remainders/remainders_list.dart';
import 'package:course_registration/service/database.dart';
import 'package:flutter/material.dart';
import 'add_remainder_screen.dart';

import 'package:provider/provider.dart';

// ignore: must_be_immutable
class Remainders extends StatefulWidget {
  static final String id = 'remainders_screen';

  @override
  _RemaindersState createState() => _RemaindersState();
}

class _RemaindersState extends State<Remainders> {
  List fetched;

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<Student>(context);
    return StreamBuilder<List<dynamic>>(
      stream: DatabaseService(uid: user.uid).remainders,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return snapshot.data.length == 0
              ? Scaffold(
                  appBar: AppBar(
                    title: Text('Remainders'),
                  ),
                  floatingActionButton: FloatingActionButton(
                    child: Icon(Icons.add),
                    onPressed: () {
                      showModalBottomSheet(
                          isScrollControlled: true,
                          context: context,
                          builder: (context) => AddRemainder(
                                addThem: (String title, String time) async {
                                  await DatabaseService(uid: user.uid)
                                      .updateUserData(
                                          snapshot.data, title, time);
                                },
                              ));
                    },
                  ),
                  body: Center(
                    child: Text('click + to add remainders'),
                  ),
                )
              : Scaffold(
                  appBar: AppBar(
                    title: Text('Remainders'),
                  ),
                  body: Column(
                    children: [
                      RemainderList(snapshot.data, (List routine, int index) {
                        DatabaseService(uid: user.uid)
                            .deleteRemainder(routine, index);
                      }),
                    ],
                  ),
                  floatingActionButtonLocation:
                      FloatingActionButtonLocation.endFloat,
                  floatingActionButton: FloatingActionButton(
                    child: Icon(Icons.add),
                    onPressed: () {
                      showModalBottomSheet(
                          context: context,
                          builder: (context) => AddRemainder(
                                addThem: (String title, String time) async {
                                  await DatabaseService(uid: user.uid)
                                      .updateUserData(
                                          snapshot.data, title, time);
                                },
                              ));
                    },
                  ),
                );
        } else {
          return Center(
            child: Text('not working'),
          );
        }
      },
    );
  }
}
