import '../../widget/MyBottomNavBar.dart';
import '/view/payment/hash_payment.dart';
import '../../../models/hashhasher_model.dart';
import '../../../repository/hashhashers_repository.dart';
import '../hash/assignHashers/assignHashers.dart';
import 'package:flutter/material.dart';
import '../../models/hash_model.dart';

class HashHashersList extends StatefulWidget {
  final Hash? hash;

  const HashHashersList({Key? key, required this.hash}) : super(key: key);

  @override
  State<HashHashersList> createState() => _HashHashersListState();
}

enum ConfirmAction { Cancel, Delete }

class _HashHashersListState extends State<HashHashersList> {
  // late List<HashHasher>? hashhasherList = [];
  HashersByHashId? hashersByHashId;
  HashHashers? hashHashers;
  List<String>? hashhasherNamesList;
  bool _isLoading = true;
  List<HasherByHash>? listHasherByHash = [];
  // String _hashTitle = '';

  Future<void> _fetchHashHasherList() async {
    load(true);
    Hash hash = widget.hash!;
    HashHasherRepository hr = HashHasherRepository();
    hashersByHashId = await hr.getHashersByHash(hash.id!);
    listHasherByHash = hashersByHashId?.getHasherByHash;
    if ((listHasherByHash?.length ?? 0) > 2) {
      listHasherByHash?.sort((a, b) => a.hasher?.compareTo(b.hasher!) ?? 0);
    }

    load(false);
  }

  load(bool val) {
    if (mounted) {
      setState(() {
        _isLoading = val;
      });
    }
  }

  Future<dynamic> deleteHasher(int id) async {
    HashHasherRepository hr = HashHasherRepository();
    return await hr.deleteHasher(id);
  }

  Future<ConfirmAction?> _asyncConfirmDialog(BuildContext context) async {
    return showDialog<ConfirmAction>(
      context: context,
      barrierDismissible: false, // user must tap button for close dialog!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete This Hasher?'),
          content: const Text('This will permanently delete a hasher.'),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop(ConfirmAction.Cancel);
              },
            ),
            TextButton(
              child: const Text('Delete'),
              onPressed: () async {
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
    // TODO: implement initState

    super.initState();
    _fetchHashHasherList();

    // getHashHasherList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0XFF006B60),
        toolbarHeight: MediaQuery.of(context).size.height * 0.2,
        title: Column(
          children: [
            Align(
              alignment: Alignment.topLeft,
              child: Text(
                widget.hash!.title! + ' - Hashers',
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
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: Colors.green,
              ),
            )
          : SingleChildScrollView(
              physics: const ClampingScrollPhysics(),
              child: Column(
                children: [
                  const SizedBox(
                    height: 18,
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Hashers List - ' + '${listHasherByHash!.length}',
                          style: TextStyle(
                              color: Color(0XFF006B60),
                              fontSize: 18,
                              fontWeight: FontWeight.w400),
                        ),
                        InkWell(
                          onTap: () async {
                            bool result = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: ((context) =>
                                    AssignHashers(hashId: widget.hash?.id!)),
                              ),
                            );
                            if (result) {
                              _fetchHashHasherList();
                            }
                          },
                          child: Row(
                            children: const [
                              CircleAvatar(
                                backgroundColor: Color(0XFF006B60),
                                radius: 6,
                                child: Icon(
                                  Icons.add,
                                  size: 10,
                                  color: Colors.white,
                                ),
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Text(
                                'Add hashers',
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
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: listHasherByHash!.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding:
                                const EdgeInsets.only(left: 16.0, right: 6),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    CircleAvatar(
                                      radius: 13,
                                      backgroundColor:
                                          Colors.grey.withOpacity(0.3),
                                      child: Text(
                                        listHasherByHash![index].hasher![0],
                                        style: const TextStyle(
                                            color: Color(0XFF006B60),
                                            fontSize: 14),
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 12,
                                    ),
                                    Text(
                                      listHasherByHash![index].hasher!,
                                      style: const TextStyle(fontSize: 16),
                                    ),
                                  ],
                                ),
                                PopupMenuButton(
                                  iconSize: 20,
                                  enabled: true,
                                  constraints:
                                      const BoxConstraints(maxWidth: 120),
                                  itemBuilder: (context) => [
                                    // PopupMenuItem(
                                    //   child: Row(
                                    //     children: [
                                    //       Icon(
                                    //         Icons.edit_outlined,
                                    //       ),
                                    //       new GestureDetector(
                                    //         child: Text('Edit'),
                                    //         onTap: () async {
                                    //           // final result = await Navigator.push(
                                    //           //   context,
                                    //           //   MaterialPageRoute(
                                    //           //     builder: ((context) =>
                                    //           //         CreateHasher(
                                    //           //           hasher: hashhasher,
                                    //           //         )),
                                    //           //   ),
                                    //           // );
                                    //           // if (result == true) {
                                    //           //   Navigator.pop(context);
                                    //           //   widget.reloadFunction!();
                                    //           // }
                                    //         },
                                    //       )
                                    //     ],
                                    //   ),
                                    // ),
                                    PopupMenuItem(
                                      child: Row(
                                        children: [
                                          const Icon(
                                            Icons.delete,
                                          ),
                                          GestureDetector(
                                            child: Text('Remove'),
                                            onTap: () async {
                                              final action =
                                                  await _asyncConfirmDialog(
                                                      context);
                                              debugPrint('action $action');
                                              if (action ==
                                                  ConfirmAction.Delete) {
                                                debugPrint('hashHasher ID: ');

                                                int hashHasherID =
                                                    listHasherByHash![index]
                                                        .id!;
                                                debugPrint(
                                                    hashHasherID.toString());
                                                Map<String, dynamic> result =
                                                    await deleteHasher(
                                                        hashHasherID);
                                                String message =
                                                    result['message'];
                                                if (result["success"] == true) {
                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(
                                                    SnackBar(
                                                        content: Text(message)),
                                                  );
                                                  // setState(() {});
                                                }
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            HashHashersList(
                                                                hash: widget
                                                                    .hash!)));
                                              } else {
                                                Navigator.of(context).pop();
                                              }
                                            },
                                          )
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          );
                        }),
                  ),
                ],
              ),
            ),
      bottomNavigationBar: MyBottomNavBar(),
    );
  }
}
