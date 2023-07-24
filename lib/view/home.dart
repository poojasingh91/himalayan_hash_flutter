import 'package:create_hash_ui/widget/MyBottomNavBar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MyHome extends StatefulWidget {
  const MyHome({Key? key}) : super(key: key);

  @override
  State<MyHome> createState() => _MyHomeState();
}

class _MyHomeState extends State<MyHome> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: const Color.fromARGB(255, 33, 68, 51),
        title: Text(
          'Himalayan Hash House Harriers',
          style: TextStyle(
            fontSize: 20,
            fontFamily: 'Montserrat',
          ),
        ),
      ),
      body: Center(
        child: Container(
          child: Text('Home Sweet Home'),
        ),
      ),
      bottomNavigationBar: MyBottomNavBar(),
    );
  }
}
