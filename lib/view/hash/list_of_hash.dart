import 'dart:convert';

import 'package:create_hash_ui/models/hash_model.dart';
import 'package:create_hash_ui/providers/hash_provider.dart';
import 'package:create_hash_ui/view/hash/add_hash.dart';
import 'package:create_hash_ui/view/hash/hash_details.dart';
import 'package:create_hash_ui/repository/hash_repository.dart';
import 'package:create_hash_ui/widget/MyBottomNavBar.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HashList extends StatefulWidget {
  const HashList({Key? key}) : super(key: key);

  @override
  State<HashList> createState() => _HashListState();
}

enum ConfirmAction { Cancel, Delete }

class _HashListState extends State<HashList> {
  late List<Hash>? hashList = [];
  late int xHashId = 0;
  bool _isLoading = true;

  Future<List<Hash>>? _hashList;

  Future<void> _fetchHashList() async {
    int _hashCount = 0;
    _hashCount = Provider.of<HashProvider>(context, listen: false).getHashCount;

    if (_hashCount <= 0) {
      print('Hash not listed yet');
      hashList =
          await Provider.of<HashProvider>(context, listen: false).loadHashes();
    } else {
      print('Hashes already listed, Get hash list from provider');
      hashList = Provider.of<HashProvider>(context, listen: false).getHashList;
    }
    //
    // HashRepository hr = HashRepository();
    // var hashes = await hr.getHashList();
    // hashList = hashes.getHashes;
  }

  void getData() async {
    await _fetchHashList();
    setState(() {
      _isLoading = false;
    });
  }

  @override
  void dispose() {
    debugPrint('List of hash: dispose called');
    super.dispose();
  }

  Future<ConfirmAction?> _asyncConfirmDialog(BuildContext context) async {
    return showDialog<ConfirmAction>(
      context: context,
      barrierDismissible: false, // user must tap button for close dialog!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete This Hash?'),
          content: const Text('This will permanently delete hash.'),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop(ConfirmAction.Cancel);
              },
            ),
            TextButton(
              child: const Text('Delete'),
              onPressed: () {
                Navigator.of(context).pop(ConfirmAction.Delete);
              },
            )
          ],
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  Future<dynamic> deleteHash(int hashId) async {
    HashRepository hr = HashRepository();
    var result = await hr.deleteHash({"id": hashId});
    // debugPrint('Hash Delete result: ');
    // String strResult = jsonEncode(result);
    // debugPrint(strResult);
    return result;
  }

  @override
  Widget build(BuildContext context) {
    print('widget build');

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Hash List',
          style: TextStyle(
            fontSize: 20,
          ),
        ),
        backgroundColor: const Color.fromARGB(255, 33, 68, 51),
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        child: RefreshIndicator(
          // onRefresh: _fetchHashList,
          onRefresh: _fetchHashList,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.fromLTRB(10, 20, 0, 5),
                    child: const Text(
                      '',
                      style: TextStyle(
                        color: Color(0XFF006B60),
                        fontSize: 20,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(10, 20, 10, 5),
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: ((context) => const AddHash()),
                          ),
                        );
                      },
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: const [
                            CircleAvatar(
                              backgroundColor: Color(0XFF006B60),
                              radius: 9,
                              child: Icon(
                                Icons.add,
                                size: 13,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(width: 8),
                            Text(
                              'New Hash',
                              style: TextStyle(
                                color: Color(0XFF006B60),
                              ),
                            )
                          ]),
                    ),
                  ),
                ],
              ),
              _isLoading
                  ? const Center(
                      child: CircularProgressIndicator(
                        color: Colors.black,
                      ),
                    )
                  : buildHashList(hashList),
            ],
          ),
        ),
      ),
      bottomNavigationBar: MyBottomNavBar(),
    );
  }

  Widget buildHashList(List<Hash>? hashList) => ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: hashList?.length ?? 0,
      itemBuilder: (context, index) {
        return Column(
          children: [
            const SizedBox(
              height: 20,
            ),
            InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: ((context) =>
                        HashDetails(hashId: hashList?[index].id ?? 0)),
                  ),
                );
              },
              child: ListTile(
                leading: Image.asset('assets/images/1.png'),
                title: Text(
                  hashList?[index].title ?? 'Title X',
                  style: TextStyle(fontSize: 14),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(hashList?[index].hashDate ?? 'NA'),
                    Text(hashList?[index].hashLocation ?? 'NA'),
                  ],
                ),
                trailing: PopupMenuButton(
                  enabled: true,
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      value: hashList?[index].id ?? 0,
                      child: Row(
                        children: [
                          const Icon(
                            Icons.edit_outlined,
                          ),
                          GestureDetector(
                            child: const Text('Edit'),
                            onTap: () {
                              final screen =
                                  AddHash(hashId: hashList?[index].id ?? 0);
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: ((context) => screen),
                                  // maintainState: false,
                                ),
                              );
                            },
                          )
                        ],
                      ),
                    ),
                    PopupMenuItem(
                      value: hashList?[index].id ?? 0,
                      child: Row(
                        children: [
                          const Icon(Icons.delete),
                          GestureDetector(
                            child: const Text('Delete'),
                            onTap: () async {
                              xHashId = hashList?[index].id ?? 0;
                              final action = await _asyncConfirmDialog(context);
                              if (action == ConfirmAction.Delete) {
                                var result = await deleteHash(xHashId);
                                String message = result['message'];
                                if (result["success"] == true) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text(message)),
                                  );
                                  setState(() {});
                                }
                              }
                              // Navigator.of(context).pop();
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => const HashList()));

                              // Navigator.pop(context, true);
                            },
                          ),
                        ],
                      ),
                      //value: 1,
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      });
}
