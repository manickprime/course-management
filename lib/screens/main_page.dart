import 'package:flutter/material.dart';

import 'navigation_screens/chat_screen.dart';
import 'navigation_screens/home.dart';
import 'navigation_screens/remainders/remainders_screen.dart';

class MainPage extends StatefulWidget {
  static String id = 'main_page';

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  // final AuthService _auth = AuthService();
  int _selectedIndex = 0;
  final _pageViewController = PageController(
    initialPage: 0,
  );
//  static List<Widget> _widgetOptions = <Widget>[
//    Home(),
//    ChatScreen(),
//    Remainders(homeWorks: rem),
//  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void dispose() {
    _pageViewController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
//      appBar: AppBar(
//        title: Text('Main page'),
//        actions: [
//          IconButton(
//            onPressed: () async {
//              await _auth.signOut();
//            },
//            icon: Icon(Icons.arrow_back_ios),
//          ),
//        ],
//      ),
      body: PageView(
        controller: _pageViewController,
        children: <Widget>[
          Home(),
          ChatScreen(),
          Remainders(),
        ],
        onPageChanged: _onItemTapped,
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat),
            label: 'Groups',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.access_time),
            label: 'Remainders',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
          _pageViewController.animateToPage(index,
              duration: Duration(milliseconds: 500), curve: Curves.ease);
        },
        selectedItemColor: Colors.blueAccent,
      ),
    );
  }
}
