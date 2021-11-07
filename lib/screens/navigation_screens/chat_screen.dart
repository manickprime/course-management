import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat room'),
      ),
      body: GestureDetector(
        onTap: () {
          print('hi');
//          Navigator.pushNamed(context, Remainders.id);
        },
        child: Column(
          children: [
            Text('This needs to be done manually for now..'),
            Text('Would be able to do group chats with @their.edu.in'),
          ],
        ),
      ),
    );
  }
}
