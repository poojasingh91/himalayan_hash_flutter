import 'dart:convert';
import 'package:create_hash_ui/view/hash/hashers/create_hasher.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import '../../../models/hasher_model.dart';
import '../../../repository/hasher_repository.dart';
import '../../../services/end_points.dart';
import '../../../widget/MyBottomNavBar.dart';
import 'alphabet_scrollview.dart';
import 'package:azlistview/azlistview.dart';

class HashersDetail extends StatefulWidget {
  final Hasher? hasher;
  const HashersDetail({Key? key, @required this.hasher}) : super(key: key);

  @override
  State<HashersDetail> createState() => _HashersDetailState();
}

class _HashersDetailState extends State<HashersDetail> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        toolbarHeight: MediaQuery.of(context).size.height * 0.4,
        title: Container(
          alignment: Alignment.center,
          child: Column(
            children: [
              CircleAvatar(
                backgroundColor: Colors.white.withOpacity(0.6),
                foregroundColor: Colors.white,
                radius: 84,
                child: Text(
                  widget.hasher!.firstName![0],
                  style: TextStyle(fontSize: 52, fontWeight: FontWeight.w500),
                ),
              ),
              SizedBox(
                height: 48,
              ),
              Text("${widget.hasher!.firstName!}",
                  style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w500,
                      color: Colors.white)),
            ],
          ),
        ),
        backgroundColor: Color(0XFF006B60),
      ),
      body: SingleChildScrollView(
        child: Container(
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 30, 20, 0),
            child: Column(
              children: [
                ListTile(
                  title: Text("First Name"),
                  trailing: Text(widget.hasher!.firstName!),
                  // tileColor: Colors.yellow,
                ),
                SizedBox(
                  height: 5,
                ),
                ListTile(
                  leading: Text("Last Name"),
                  trailing: Text(widget.hasher!.lastName!),
                  // tileColor: Colors.yellow,
                ),
                SizedBox(
                  height: 5,
                ),
                ListTile(
                  leading: Text("Country"),
                  trailing: Text(widget.hasher!.countryId!),
                  // tileColor: Colors.yellow,
                ),
                SizedBox(
                  height: 5,
                ),
                ListTile(
                  leading: Text("No. of Hashes till date"),
                  trailing: Text("${widget.hasher!.noOfHashesToDate!}"),
                  // tileColor: Colors.yellow,
                ),
                SizedBox(
                  height: 5,
                ),
                ListTile(
                  leading: Text("Hashes Hared"),
                  trailing: Text("${widget.hasher!.noOfHashesHared!}"),
                  // tileColor: Colors.yellow,
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: MyBottomNavBar(),
    );
  }
}
