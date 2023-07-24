// import 'dart:html';

import 'package:azlistview/azlistview.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:create_hash_ui/repository/hasher_repository.dart';
import 'package:create_hash_ui/models/hasher_model.dart';
import 'package:create_hash_ui/providers/hasher_provider.dart';
import 'package:provider/provider.dart';
import '../../../widget/MyBottomNavBar.dart';
import 'alphabet_scrollview.dart';
import 'create_hasher.dart';

class HasherList extends StatefulWidget {
  const HasherList({Key? key}) : super(key: key);

  @override
  State<HasherList> createState() => _HasherListState();
}

class _HasherListState extends State<HasherList> {
  late Hashers? hashers;
  late List<Hasher>? hasherList = [];
  List<String>? hasherNamesList;
  bool _isLoading = true;

  Future<void> _fetchHasherList() async {
    int hasherCount = 0;
    hasherCount =
        Provider.of<HasherProvider>(context, listen: false).hasherList.length ??
            0;
    if (hasherCount <= 0) {
      // print('Hasher not listed yet');
      hasherList = await Provider.of<HasherProvider>(context, listen: false)
          .loadHashers();
    } else {
      // print('Hasher already listed, Get hasher list from provider');
      hasherList =
          Provider.of<HasherProvider>(context, listen: false).hasherList;
    }

    // HasherRepository hr = HasherRepository();
    // hashers = await hr.getHasherList();
    // hasherList = hashers?.getHashers;
    hasherNamesList =
        hasherList?.map((e) => "${e.firstName!} ${e.lastName!}").toList();
    hasherNamesList!.sort();

    print(hasherList!.length);

    load(false);
  }

  load(bool val) {
    if (mounted) {
      setState(() {
        _isLoading = val;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchHasherList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: const Color.fromARGB(255, 33, 68, 51),
        toolbarHeight: MediaQuery.of(context).size.height * 0.2,
        title: Column(
          children: [
            Align(
              alignment: Alignment.topLeft,
              child: Text(
                'Hashers List',
                style: TextStyle(
                  fontSize: 20,
                  fontFamily: 'Montserrat',
                ),
              ),
            ),
            SizedBox(
              height: 15,
            ),
            Container(
              width: double.infinity,
              height: 40,
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(18)),
              child: Center(
                child: TextField(
                  decoration: InputDecoration(
                      contentPadding: EdgeInsets.all(10),
                      hintStyle: TextStyle(color: Colors.grey, fontSize: 17),
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.search),
                        onPressed: () {
                          /*search field */
                        },
                      ),
                      hintText: 'Search here',
                      border: InputBorder.none),
                ),
              ),
            ),
          ],
        ),
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: Colors.green,
              ),
            )
          : SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(
                    height: 18,
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Manage Hashers',
                          style: TextStyle(
                            // color: const Color.fromARGB(255, 33, 68, 51),
                            color: Color(0XFF006B60),
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        InkWell(
                          onTap: () async {
                            final result = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: ((context) => CreateHasher()),
                              ),
                            );
                            print(result);
                            if (result == true) {
                              _fetchHasherList();
                            }
                          },
                          child: Row(
                            children: [
                              CircleAvatar(
                                backgroundColor: Color(0XFF006B60),
                                radius: 8,
                                child: Icon(
                                  Icons.add,
                                  size: 14,
                                  color: Colors.white,
                                ),
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Text(
                                'Add hasher',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Color(0XFF006B60),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    height: 500,
                    child: AlphabetScrollPage(
                      items: hasherNamesList,
                      hashersList: hasherList,
                      reloadFunction: _fetchHasherList,
                    ),
                  ),
                ],
              ),
            ),
      bottomNavigationBar: MyBottomNavBar(),
    );
  }
}
