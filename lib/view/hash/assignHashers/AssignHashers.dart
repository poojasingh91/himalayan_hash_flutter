import 'package:flutter/material.dart';
import '../../../models/hash_model.dart';
import '../../../widget/MyBottomNavBar.dart';
import '../hashHashersList.dart';
import 'alphabet_scroll.dart';
import '../../../models/hashhasher_model.dart';
import '../../../repository/hashhashers_repository.dart';
import '../../../repository/hash_repository.dart';
import '../../../models/hasher_model.dart';

class AssignHashers extends StatefulWidget {
  final int? hashId;
  const AssignHashers({Key? key, this.hashId}) : super(key: key);

  @override
  State<AssignHashers> createState() => _AssignHashersState();
}

class _AssignHashersState extends State<AssignHashers> {
  late List<Hasher>? unassignedHashers = [];
  List<String>? hashhasherNamesList;
  List<int> _hashserList = [];
  late HashDetail _hashDetail;
  late Hash _hash;

  bool _isLoading = true;

  Map<String, dynamic> _newHasherList = {
    "hash_id": 0,
    "hasher_id[]": [],
  };

  Future<void> _getHash() async {
    HashRepository hr = HashRepository();
    _hashDetail = await hr.getHash(widget.hashId!);
    _hash = _hashDetail.getHash!;
  }

  Future<void> _unassignedMethod() async {
    load(true);
    HashHasherRepository hr = HashHasherRepository();
    unassignedHashers = await hr.getUnassignedList(widget.hashId!);
    hashhasherNamesList = unassignedHashers
        ?.map((e) => "${e.firstName!} ${e.lastName!}")
        .toList();
    hashhasherNamesList!.sort();
    load(false);
  }

  load(bool val) {
    if (mounted) {
      setState(() {
        _isLoading = val;
      });
    }
  }

  void updateHasherList(List<int> hl) {
    setState(() {
      _hashserList = hl;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _unassignedMethod();
    _getHash();
    _newHasherList['hash_id'] = widget.hashId;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0XFF006B60),
        // toolbarHeight: 160,
        toolbarHeight: MediaQuery.of(context).size.height * 0.2,
        title: Column(
          children: [
            const Align(
              alignment: Alignment.topLeft,
              child: Text(
                'Assign Hashers',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.normal),
              ),
            ),
            const SizedBox(
              height: 40,
            ),
            Container(
              width: double.infinity,
              height: 45,
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(18)),
              child: Center(
                child: TextField(
                  decoration: InputDecoration(
                      contentPadding: const EdgeInsets.all(10),
                      hintStyle:
                          const TextStyle(color: Colors.grey, fontSize: 17),
                      suffixIcon: Transform.rotate(
                        angle: 1.5,
                        child: IconButton(
                          icon: const Icon(Icons.search),
                          onPressed: () {
                            /*search field */
                          },
                        ),
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
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 5),
                    child: Container(
                        height: MediaQuery.of(context).size.height * 0.64,
                        child: AlphabetScroll(
                            // items: hashhasherNamesList,
                            hashers: unassignedHashers,
                            onHashListChanged: (List<int> hl) {
                              updateHasherList(hl);
                              debugPrint('Printing selected hash from Parent');
                              debugPrint(_hashserList.toString());
                            })),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 2),
                    child: Center(
                      child: ElevatedButton(
                        onPressed: () async {
                          debugPrint('No. of hashers selected:');
                          debugPrint(_hashserList.length.toString());
                          if (_hashserList.length > 0) {
                            HashHasherRepository hr = HashHasherRepository();
                            _newHasherList['hasher_id[]'] = _hashserList;
                            // _unassignedMethod();
                            Map<String, dynamic> result =
                                await hr.addHashersToHash(_newHasherList);
                            if (result['success'] == true) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text(result['message'])),
                              );
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text(result['message'])),
                              );
                            }
                            Navigator.pop(context, true);
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.only(top: 2, bottom: 2),
                          // fixedSize: Size(
                          //     MediaQuery.of(context).size.width * 0.25,
                          //     MediaQuery.of(context).size.height * 0.07),
                          minimumSize: Size(
                              MediaQuery.of(context).size.width * 0.28,
                              MediaQuery.of(context).size.height * 0.065),
                          maximumSize: Size(
                              MediaQuery.of(context).size.width * 0.35,
                              MediaQuery.of(context).size.height * 0.08),
                          primary: const Color(0XFF006B60),
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(8)),
                          ),
                        ),
                        child: const Text(
                          'Assign',
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
      bottomNavigationBar: MyBottomNavBar(),
    );
  }
}
