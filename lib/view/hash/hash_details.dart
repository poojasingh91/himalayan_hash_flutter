// import 'package:create_hash_ui/models/hasher_model.dart';
// import 'package:create_hash_ui/view/hash/hashHashersList.dart';

import 'dart:developer';

import 'package:create_hash_ui/models/hashhasher_model.dart';
import 'package:create_hash_ui/repository/hashhashers_repository.dart';
import 'package:create_hash_ui/view/payment/hash_payment.dart';

import '../../models/hasher_model.dart';
import 'hashHashersList.dart';

import 'package:flutter/material.dart';
import '../../models/hash_model.dart';
import '../../repository/hash_repository.dart';
import '../../services/end_points.dart';

class HashDetails extends StatefulWidget {
  final int? hashId;
  final Hash? hash;
  const HashDetails({
    Key? key,
    this.hashId,
    this.hash,
  }) : super(key: key);

  @override
  State<HashDetails> createState() => _HashDetailsState();
}

class _HashDetailsState extends State<HashDetails> {
  String baseUrl = EndPoints.baseUrl;

  bool _isLoading = false;

  Hash? hash;
  HashDetail? hd;

  String startingPoint = '';
  String endingPoint = '';
  String startAndEndPoint = '';
  String title = '';
  String hashDate = '';
  String hashTime = '';
  String hashDay = '';
  String hashLocation = '';
  String specialOccasion = '';
  String description = '';
  String bannerImage = '';
  int noOfHashers = 0;
  List<Hasher>? hares = [];

  late Hasher hare;

  HashersByHashId? hashersByHashId;
  HashHashers? hashHashers;
  List<String>? hashhasherNamesList;
  bool _isLoad = true;
  List<HasherByHash>? listHasherByHash = [];
  // String _hashTitle = '';

  Future<void> _fetchHashHasherList() async {
    load(true);
    HashHasherRepository hr = HashHasherRepository();
    hashersByHashId = await hr.getHashersByHash(widget.hashId!);
    listHasherByHash = hashersByHashId?.getHasherByHash;
    if ((listHasherByHash?.length ?? 0) > 2) {
      listHasherByHash?.sort((a, b) => a.hasher?.compareTo(b.hasher!) ?? 0);
    }
    load(false);
  }

  load(bool val) {
    if (mounted) {
      setState(() {
        _isLoad = val;
      });
    }
  }

  _fetchHash() async {
    int hashId = 0;
    setState(() {
      _isLoading = true;
    });

    HashRepository hr = HashRepository();
    hashId = widget.hashId ?? 0;

    hd = await hr.getHash(hashId);
    hash = hd?.hash;

    title = hash?.title ?? '';
    hashDate = hash?.hashDate ?? '';
    hashTime = hash?.time ?? '';
    startingPoint = hash?.startingPoint ?? '';
    endingPoint = hash?.endingPoint ?? '';
    startAndEndPoint = '$startingPoint - $endingPoint';
    hashLocation = hash?.hashLocation ?? '';
    specialOccasion = hash?.specialOccasion ?? '';
    description = hash?.description ?? '';
    bannerImage = hash?.bannerImage ?? '';
    log(bannerImage);

    hashDay = hd?.day ?? '';
    noOfHashers = hd?.noOfHashers ?? 0;

    hares = hd?.getHares;
    debugPrint('hares count: ${hares?.length.toString()}');

    setState(() {
      _isLoading = false;
    });
  }

  @override
  void initState() {
    _fetchHash();
    _fetchHashHasherList();
    super.initState();
  }

  Align _getTitle(String title) {
    return Align(
      alignment: Alignment.topLeft,
      child: Padding(
        padding: const EdgeInsets.only(left: 13),
        child: Text(
          title,
          textAlign: TextAlign.left,
          style: const TextStyle(
            color: Color(0XFF006B60),
            fontSize: 16,
            fontFamily: 'Monteserrat',
          ),
        ),
      ),
    );
  }

  Text _getContent(String textLabel) {
    return Text(
      textLabel,
      textAlign: TextAlign.left,
      style: const TextStyle(
        color: Color(0XFF3A3A3A),
        fontSize: 16,
        fontFamily: 'Monteserrat',
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: (_isLoading)
            ? Center(
                child: Container(
                  alignment: Alignment.center,
                  margin: const EdgeInsets.all(10),
                  child: const CircularProgressIndicator(
                    color: Colors.green,
                  ),
                ),
              )
            : SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Stack(
                      children: [
                        (bannerImage.isNotEmpty)
                            // ? Image.network('http://127.0.0.1:8000/' + bannerImage)
                            ? FittedBox(
                                child: Expanded(
                                  child: Container(
                                    width: MediaQuery.of(context).size.width,
                                    height: MediaQuery.of(context).size.height *
                                        0.3,
                                    decoration: BoxDecoration(
                                        image: DecorationImage(
                                      scale: 8,
                                      fit: BoxFit.cover,
                                      image: NetworkImage(
                                          // width: double.infinity,
                                          '${EndPoints.imageBaseUrl}$bannerImage',
                                          // headers: {"Keep-Alive": "true"}
                                          headers: const {
                                            // "Keep-Alive": "timeout=5, max=1000",
                                            "Connection": "Keep-Alive",
                                            "Keep-Alive": "timeout=5",
                                          }),
                                    )),
                                  ),
                                ),
                              )
                            : FittedBox(
                                child: Expanded(
                                  child: Container(
                                    width: MediaQuery.of(context).size.width,
                                    height: MediaQuery.of(context).size.height *
                                        0.3,
                                    child: const Icon(
                                      Icons.not_interested_sharp,
                                      size: 255,
                                    ),
                                  ),
                                ),
                              ),
                        Positioned(
                          top: 20,
                          left: 20,
                          child: InkWell(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Container(
                              padding: const EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                  color: Colors.green,
                                  borderRadius: BorderRadius.circular(6)),
                              child: const Icon(
                                Icons.arrow_back,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    Align(
                      alignment: Alignment.topLeft,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 13),
                        child: Text(
                          title,
                          style: const TextStyle(
                            fontSize: 22,
                            color: Color(0XFF006B60),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 12,
                    ),

                    Align(
                      alignment: Alignment.topLeft,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 13, right: 13),
                        child: _getContent(description),
                      ),
                    ),
                    const SizedBox(
                      height: 17,
                    ),
                    Column(
                      children: [
                        _getTitle("Hash Date"),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Align(
                              alignment: Alignment.topLeft,
                              child: Padding(
                                padding: const EdgeInsets.only(left: 13),
                                child: _getContent(hashDate),
                              ),
                            ),
                            const SizedBox(
                              width: 20,
                            ),
                            _getContent(hashTime),
                          ],
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 17,
                    ),
                    Column(
                      children: [
                        _getTitle("Hash day"),
                        Align(
                          alignment: Alignment.topLeft,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 13),
                            child: _getContent(hashDay),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 17,
                    ),
                    Column(
                      children: [
                        _getTitle("Hashers"),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Align(
                              alignment: Alignment.topLeft,
                              child: Padding(
                                padding: const EdgeInsets.only(left: 13),
                                child: _getContent(noOfHashers.toString()),
                              ),
                            ),
                            const SizedBox(
                              width: 32,
                            ),
                            InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: ((context) =>
                                        HashHashersList(hash: hash!)),
                                  ),
                                );
                              },
                              child: Text(
                                'View Hashers',
                                style: TextStyle(
                                  color: Color(0XFF006B60),
                                  fontSize: 14,
                                  fontStyle: FontStyle.normal,
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 32,
                            ),
                            InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: ((context) => HashPayment(
                                          hash: hash,
                                          hashhasherList: listHasherByHash,
                                        )),
                                  ),
                                );
                              },
                              child: Text(
                                'Payment',
                                style: TextStyle(
                                  color: Color(0XFF006B60),
                                  fontSize: 14,
                                  fontStyle: FontStyle.normal,
                                ),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 17,
                    ),
                    Column(
                      children: [
                        _getTitle("Location"),
                        Align(
                          alignment: Alignment.topLeft,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 13),
                            child: _getContent(hash?.hashLocation ?? ''),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Column(
                      children: [
                        Align(
                          alignment: Alignment.topLeft,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 13),
                            child: _getContent(startAndEndPoint),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 17,
                    ),
                    Column(
                      children: [
                        _getTitle("Special Occasion"),
                        Align(
                          alignment: Alignment.topLeft,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 13),
                            child: _getContent(hash?.specialOccasion ?? ''),

                            // Text(
                            //   hash?.specialOccasion ?? '',
                            //   textAlign: TextAlign.left,
                            //   style: TextStyle(
                            //     color: Color(0XFF3A3A3A),
                            //     fontSize: 16,
                            //     fontFamily: 'Monteserrat',
                            //   ),
                            // ),
                          ),
                        ),
                      ],
                    ),
                    // SizedBox(
                    //   height: 17,
                    // ),
                    // Column(
                    //   children: [
                    //     Align(
                    //       alignment: Alignment.topLeft,
                    //       child: Padding(
                    //         padding: const EdgeInsets.only(left: 13),
                    //         child: _getContent(hash?.startingPoint ?? ''),
                    //         // Text(
                    //         //   hash?.startingPoint ?? '',
                    //         //   textAlign: TextAlign.left,
                    //         //   style: TextStyle(
                    //         //     color: Color(0XFF3A3A3A),
                    //         //     fontSize: 16,
                    //         //     fontFamily: 'Monteserrat',
                    //         //   ),
                    //         // ),
                    //       ),
                    //     ),
                    //   ],
                    // ),
                    const SizedBox(
                      height: 17,
                    ),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _getTitle("Hares"),
                        Align(
                          alignment: Alignment.topLeft,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 13),
                            child: (hares != null)
                                ? _buildHareList(hares!)
                                : Text('Not assigned yet'),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 36,
                    ),
                  ],
                ),
              ),
      ),
    );
  }

  Widget _buildHareList(List<Hasher> hares) => ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: hares.length ?? 0,
      itemBuilder: (context, index) {
        // debugPrint('counter: $index');
        final hare = hares[index];
        String fullName = (index + 1).toString() +
            '. ' +
            hare.firstName! +
            ' ' +
            hare.lastName!;
        return ListTile(
          title: Text(fullName),
          visualDensity: VisualDensity(horizontal: 0, vertical: -4),
          contentPadding: EdgeInsets.symmetric(horizontal: 0.0, vertical: 0.0),
        );
      });
}
