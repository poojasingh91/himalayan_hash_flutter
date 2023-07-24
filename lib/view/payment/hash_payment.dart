import 'dart:developer';
import 'package:get/get.dart';

import '/models/payment_model.dart';
import '/repository/payment_repository.dart';
import '../hash/assignHashers/assignHashers.dart';
import '../hash/hashHashersList.dart';
import '/models/hash_model.dart';
import '/models/hashhasher_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HashPayment extends StatefulWidget {
  // final Payment? payment;
  final Hash? hash;
  final int? hashId;
  final List<HasherByHash>? hashhasherList;
  HashPayment({
    Key? key,
    this.hash,
    this.hashhasherList,
    this.hashId,
  }) : super(key: key);

  @override
  State<HashPayment> createState() => _HashPaymentState();
}

class _HashPaymentState extends State<HashPayment> {
  List<int> indexList = [];
  late dynamic toggled;
  late List<HasherByHash>? hashhasherList = [];
  var hashHashersIdList = [];
  late List<HasherPayment>? paidhasherList = [];
  List<String>? paidNamesList;
  List<int> paidHasherIdList = [];

  List<String>? hashhasherNamesList;
  bool _isLoading = true;
  List<List<bool>>? _isToggledList;
  List<List<String>>? _stringToggledList;

  List result1 = [];
  List result2 = [];
  List result3 = [];
  // Future<void> _deleteHasherList() async{}

  Future<void> _fetchHashHasherList() async {
    hashhasherList = widget.hashhasherList;
    _isToggledList =
        List.generate(hashhasherList!.length, (index) => [false, false, false]);
    _stringToggledList = List.generate(hashhasherList!.length,
        (index) => ['not_paid', 'not_paid', 'not_paid']);

    hashhasherNamesList = hashhasherList?.map((e) => "${e.hasher} ").toList();
    hashhasherNamesList!.sort();
    _fetchHasherPayment();
  }

  Future<void> _fetchHasherPayment() async {
    PaymentRepository pr = PaymentRepository();
    paidhasherList = await pr.getToggledData(widget.hash!.id!);
    paidhasherList!.forEach((element) {
      paidHasherIdList.add(element.hasherId!);
    });
    setInitialToggle();
    paidNamesList = paidhasherList?.map((e) => "${e.hasher!}").toList();
    paidNamesList!.sort();
  }

  Future<dynamic> updatePayment() async {
    final myPay = {
      "hash_id": widget.hash!.id!,
      "hasher_id[]": hashHashersIdList,
      'running_payment_status[]': result1,
      'drink_payment_status[]': result2,
      'hard_drink_payment_status[]': result3,
    };

    PaymentRepository hr = PaymentRepository();
    final result = await hr.updatePayment(myPay);

    hashHashersIdList.clear();
    result1.clear();
    result2.clear();
    result3.clear();
    return result;
  }

  void setInitialToggle() {
    for (int index = 0; index < _isToggledList!.length; index++) {
      if (paidHasherIdList.contains(hashhasherList![index].hasherId) &&
          paidhasherList![paidHasherIdList
                      .indexOf(hashhasherList![index].hasherId!)]
                  .runningPaymentStatus ==
              "paid") {
        _isToggledList![index][0] = true;
        _stringToggledList![index][0] = "paid";
      }
      if (paidHasherIdList.contains(hashhasherList![index].hasherId) &&
          paidhasherList![paidHasherIdList
                      .indexOf(hashhasherList![index].hasherId!)]
                  .drinkPaymentStatus ==
              "paid") {
        _isToggledList![index][1] = true;
        _stringToggledList![index][1] = "paid";
      }
      if (paidHasherIdList.contains(hashhasherList![index].hasherId) &&
          paidhasherList![paidHasherIdList
                      .indexOf(hashhasherList![index].hasherId!)]
                  .hardDrinkPaymentStatus ==
              "paid") {
        _isToggledList![index][2] = true;
        _stringToggledList![index][2] = "paid";
      }
    }

    log('------_stringToggledList------>' + '${_stringToggledList}');
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
    _fetchHashHasherList();
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
                '${widget.hash?.title}' + ' - Payment',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.normal),
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
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                child: Column(
                  children: [
                    const SizedBox(
                      height: 18,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Hashers List - ' + '${hashhasherNamesList!.length}',
                          style: TextStyle(
                              color: Color(0XFF006B60),
                              fontSize: 16,
                              fontWeight: FontWeight.w400),
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: ((context) => AssignHashers(
                                      hashId: widget.hash?.id!,
                                    )),
                              ),
                            );
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
                                  fontSize: 10,
                                  color: Color(0XFF006B60),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 18,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Column(
                          children: const [
                            Text(
                              'Name',
                              style: TextStyle(
                                  color: Color(0XFF006B60),
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400),
                            ),
                            SizedBox(
                              height: 18,
                            ),
                          ],
                        ),
                        const SizedBox(
                          width: 32,
                        ),
                        Column(
                          children: const [
                            Text(
                              'Entry fee',
                              style: TextStyle(
                                fontSize: 16,
                                color: Color(0XFF006B60),
                              ),
                            ),
                            Text(
                              '(200)',
                              style: TextStyle(
                                fontSize: 12,
                                color: Color(0XFF006B60),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          width: 12,
                        ),
                        Column(
                          children: const [
                            Text(
                              'Beverage',
                              style: TextStyle(
                                fontSize: 16,
                                color: Color(0XFF006B60),
                              ),
                            ),
                            Text(
                              'Drink/Beer',
                              style: TextStyle(
                                fontSize: 12,
                                color: Color(0XFF006B60),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Container(
                      height: MediaQuery.of(context).size.height * 0.5,
                      child: ListView.builder(
                          shrinkWrap: true,
                          // physics: const NeverScrollableScrollPhysics(),
                          itemCount: hashhasherNamesList!.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.fromLTRB(0, 2, 2, 2),
                              child: Table(
                                children: [
                                  TableRow(children: [
                                    Container(
                                      height: 56,
                                      child: Row(
                                        children: [
                                          CircleAvatar(
                                            radius: 13,
                                            backgroundColor:
                                                Colors.grey.withOpacity(0.3),
                                            child: Text(
                                              hashhasherNamesList![index][0],
                                              style: const TextStyle(
                                                  color: Color(0XFF006B60),
                                                  fontSize: 12),
                                            ),
                                          ),
                                          SizedBox(
                                            width: 8,
                                          ),
                                          Flexible(
                                            flex: 2,
                                            child: Text(
                                              maxLines: 3,
                                              hashhasherNamesList![index],
                                              style:
                                                  const TextStyle(fontSize: 16),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                    Container(
                                      height: 56,
                                      child: Transform.scale(
                                        scale: 0.7,
                                        child: CupertinoSwitch(
                                          value: _isToggledList![index][0],
                                          onChanged: (bool value) {
                                            setState(() {
                                              _isToggledList![index][0] = value;
                                              if (_isToggledList![index][0]) {
                                                _stringToggledList![index][0] =
                                                    'paid';
                                              } else {
                                                _stringToggledList![index][0] =
                                                    'not_paid';
                                              }
                                            });
                                          },
                                        ),
                                      ),
                                    ),
                                    Container(
                                      height: 56,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Transform.scale(
                                            scale: 0.7,
                                            child: CupertinoSwitch(
                                              value: _isToggledList![index][1],
                                              onChanged: (bool value) {
                                                setState(() {
                                                  _isToggledList![index][1] =
                                                      value;
                                                  if (_isToggledList![index]
                                                      [1]) {
                                                    _stringToggledList![index]
                                                        [1] = 'paid';
                                                  } else {
                                                    _stringToggledList![index]
                                                        [1] = 'not_paid';
                                                  }
                                                });
                                              },
                                            ),
                                          ),
                                          Transform.scale(
                                            scale: 0.7,
                                            child: CupertinoSwitch(
                                              value: _isToggledList![index][2],
                                              onChanged: (bool value) {
                                                setState(() {
                                                  _isToggledList![index][2] =
                                                      value;
                                                  if (_isToggledList![index]
                                                      [2]) {
                                                    _stringToggledList![index]
                                                        [2] = 'paid';
                                                  } else {
                                                    _stringToggledList![index]
                                                        [2] = 'not_paid';
                                                  }
                                                });
                                              },
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ])
                                ],
                              ),
                            );
                          }),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Center(
                        child: ElevatedButton(
                          child: Text(
                            'Save',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w400),
                          ),
                          onPressed: () async {
                            _isToggledList!.forEach((element) {
                              // if (element.contains(true)) {
                              indexList.add(_isToggledList!.indexOf(element));
                              // }
                            });

                            for (var i in indexList) {
                              hashhasherList!.forEach((element) {
                                if (hashhasherList!.indexOf(element) == i) {
                                  hashHashersIdList.add(element.hasherId);
                                }
                              });
                            }
                            for (var i in indexList) {
                              result1.add(_stringToggledList![i][0]);
                              result2.add(_stringToggledList![i][1]);
                              result3.add(_stringToggledList![i][2]);
                            }
                            print('result1----' + '${result1}');
                            print('result2' + '${result2}');
                            print('result3' + '${result3}');

                            var result = await updatePayment();
                            if (result['success'] == true) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text(result['message'])),
                              );
                              Navigator.pop(context);
                            }
                          },
                          style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.only(left: 40, right: 40),
                              fixedSize: Size(120, 45),
                              primary: Color(0XFF006B60),
                              shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(12)),
                              )),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
