import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AddRemainder extends StatefulWidget {
  final Function addThem;

  AddRemainder({this.addThem});

  @override
  _AddRemainderState createState() => _AddRemainderState();
}

class _AddRemainderState extends State<AddRemainder> {
  String remainderTitle;

  String remainderTime;

  final remTitleController = TextEditingController();

  final remTimeController = TextEditingController();
  final focus = FocusNode();

  @override
  void initState() {
    print("i've been built again");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 500,
      child: Center(
        child: Column(
          children: [
            Text(
              'Add task',
            ),
            TextFormField(
              controller: remTitleController,
              textAlign: TextAlign.center,
              autofocus: true,
              onChanged: (newText) {
//                setState(() {
//                  remainderTitle = newText;
//                });
                remainderTitle = newText;
//                print(remainderTitle);
              },
              onFieldSubmitted: (newText) {
                remainderTitle = newText;
                FocusScope.of(context).requestFocus(focus);
              },
            ),
            TextFormField(
              focusNode: focus,
              controller: remTimeController,
              textAlign: TextAlign.center,
              autofocus: true,
              onChanged: (newText) {
//                setState(() {
//                  remainderTime = newText;
//                });
                remainderTime = newText;
//                print(remainderTime);
              },
              onFieldSubmitted: (newText) {
                remainderTime = newText;
              },
            ),
            TextButton(
              child: Text('add'),
              // color: Colors.blueAccent,
              onPressed: () {
//                print(remTitleController.text);
//                print(remTimeController.text);
                widget.addThem(remTitleController.text, remTimeController.text);
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}
