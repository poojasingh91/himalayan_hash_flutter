import 'package:flutter/material.dart';

import '../view/hash/hashers/list_of_hashers.dart';
import '../view/hash/list_of_hash.dart';
import '../view/home.dart';

class MyBottomNavBar extends StatefulWidget {
  MyBottomNavBar({Key? key}) : super(key: key);

  @override
  State<MyBottomNavBar> createState() => _MyBottomNavBarState();
}

late int _selectedIndex = 0;

class _MyBottomNavBarState extends State<MyBottomNavBar> {
  final pageOptions = [
    new MyHome(),
    new HashList(),
    new HasherList(),
    new MyHome(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    debugPrint('old index: $index , new index: $_selectedIndex');
    // if (index != _selectedIndex) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: ((context) => pageOptions[index]),
      ),
    );
    // }
  }

  @override
  Widget build(BuildContext context) {
    // print('selectedIndex inside build: $_selectedIndex');
    return BottomNavigationBar(
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
        BottomNavigationBarItem(
            icon: Icon(Icons.run_circle_outlined), label: 'Hash'),
        BottomNavigationBarItem(icon: Icon(Icons.people), label: 'Hashers'),
        BottomNavigationBarItem(icon: Icon(Icons.logout), label: 'Logout'),
      ],

      currentIndex: _selectedIndex,
      onTap: _onItemTapped,
      elevation: 0,
      type: BottomNavigationBarType.fixed,

      showSelectedLabels: false,
      showUnselectedLabels: false,

      selectedItemColor: Colors.deepOrangeAccent,
      selectedIconTheme:
          IconThemeData(color: Colors.deepOrangeAccent, size: 30),
      unselectedIconTheme: IconThemeData(
        color: Colors.blueGrey,
      ),
      // backgroundColor: Colors.blueAccent,
    );
  }
}
