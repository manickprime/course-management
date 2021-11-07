import 'package:course_registration/service/auth.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    final AuthService _auth = AuthService();

    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
      ),
      body: Center(
        child: Text('This is screens.home'),
      ),
      drawer: Drawer(
        child: Column(
          children: [
            UserAccountsDrawerHeader(
              accountName: Text('Nick'),
              accountEmail: Text('toad@gmail.com'),
              currentAccountPicture: CircleAvatar(
                backgroundColor: Colors.white,
                child: Text(
                  'xyz',
                  style: TextStyle(color: Colors.lightBlueAccent),
                ),
              ),
              otherAccountsPictures: [
                CircleAvatar(
                  backgroundColor: Colors.white,
                  child: Text(
                    'abc',
                    style: TextStyle(color: Colors.lightBlueAccent),
                  ),
                ),
              ],
            ),
            ListTile(
              title: Text('Remainders'),
              leading: Icon(Icons.timer),
              onTap: () {},
            ),
            Divider(
              height: 0.1,
            ),
            ListTile(
              title: Text('Primary'),
              leading: Icon(Icons.inbox),
            ),
            ListTile(
              title: Text('Social'),
              leading: Icon(Icons.inbox),
            ),
            ListTile(
              title: Text('Promotions'),
              leading: Icon(Icons.inbox),
            ),
            ListTile(
              title: Text('Log Out'),
              leading: Icon(Icons.arrow_back_ios),
              onTap: () async {
                await _auth.signOut();
              },
            ),
          ],
        ),
      ),
    );
  }
}
