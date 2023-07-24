import 'dart:convert';
import 'dart:io';
import 'package:create_hash_ui/models/hasher_model.dart';
import 'package:create_hash_ui/repository/hash_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import '../../models/hash_model.dart';
import '../../repository/hasher_repository.dart';
import '../../services/file_service.dart';
import '../../widget/common_textfield.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'list_of_hash.dart';

class AddHash extends StatefulWidget {
  final int? hashId;
  const AddHash({Key? key, this.hashId}) : super(key: key);

  @override
  State<AddHash> createState() => _AddHashState();
}

class _AddHashState extends State<AddHash> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _hashNumberController = TextEditingController();
  final TextEditingController _hashDateController = TextEditingController();
  final TextEditingController _hashTimeController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _startingPointController =
      TextEditingController();
  final TextEditingController _endingPointController = TextEditingController();
  final TextEditingController _specialOccasionController =
      TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  bool _isLoading = false;
  bool isEditing = false;
  bool _isDataFetched = false;

  int hashId = 0;
  Hash? hash;
  HashDetail? hd;

  //For image
  List<File> imageList = [];

  File? bannerImage;

  String _date = "Hash Date";
  var presentDateTime = DateTime.now();
  var presentDate = '';
  String time = '';

  // Create a global key that uniquely identifies the Form widget and allows validation of the form.
  final _formKey = GlobalKey<FormState>();

  HashRepository hr = HashRepository();

  Map<String, dynamic> hashInfo = {
    "id": 0,
    "title": "Mero blank title",
    "hash_number": "",
    "hash_date": "",
    "time": "",
    "hash_location": "",
    "starting_point": "",
    "ending_point": "",
    "special_occasion": "",
    "description": "",
    "banner_image": "",
    "hare_list[]": []
  };

  // late final _items;
  List<MultiSelectItem<int>> _items = [];
  late List<int> _selectedHares = [];
  // List<MultiSelectItem<int>> _hashers = [];
  List<Hasher>? hasherList = [];
  Hashers? hs;
  late Hasher h;
  TimeOfDay _hashTime = TimeOfDay(hour: 2, minute: 15);

  Future _fetchHasher() async {
    debugPrint('_fetchHasher function called');
    HasherRepository hashers = HasherRepository();
    hs = await hashers.getHasherList();
    hasherList = hs?.hashers;
    hasherList?.sort((a, b) => a.firstName?.compareTo(b.firstName!) ?? 0);

    if (hasherList != null) {
      // _hashers = hasherList?.map((hasher) => hasher.firstName).toList();
      _items = hasherList!
          .map((hasher) => MultiSelectItem(
              hasher.id!, hasher.firstName! + ' ' + hasher.lastName!))
          .toList();
    }
  }

  Future _fetchHash() async {
    HashRepository hr = HashRepository();
    int hashId = widget.hashId ?? 0;
    debugPrint('hashId: $hashId');
    hd = await hr.getHash(hashId);
    List<Hasher>? hareList = hd?.getHares;
    var strHares = jsonEncode(hareList);

    if (hareList != null) {
      hareList.forEach((hare) {
        _selectedHares.add(hare.id!);
      });
    }
    debugPrint('Selected hares:');
    debugPrint(_selectedHares.toString());

    hash = hd?.hash;
    hashInfo['id'] = (hashId > 0) ? hashId : 0;
    hashInfo['title'] = hash?.title;
    hashInfo['hash_number'] = hash?.hashNumber;
    hashInfo['hash_date'] = hash?.hashDate;
    hashInfo['time'] = hash?.time;
    hashInfo['hash_location'] = hash?.hashLocation;
    hashInfo['starting_point'] = hash?.startingPoint;
    hashInfo['ending_point'] = hash?.endingPoint;
    hashInfo['special_occasion'] = hash?.specialOccasion;
    hashInfo['description'] = hash?.description;
    hashInfo['banner_image'] = hash?.bannerImage;
    // hashInfo['hare_list'] = hash?.hareList;

    _titleController.text = hashInfo['title']!;
    _hashNumberController.text = hashInfo['hash_number'];
    _hashDateController.text = hashInfo['hash_date'];
    _hashTimeController.text = hashInfo['time'];
    _locationController.text = hashInfo['hash_location'];
    _startingPointController.text = hashInfo['starting_point'];
    _endingPointController.text = hashInfo['ending_point'];
    _specialOccasionController.text = hashInfo['special_occasion'];
    _descriptionController.text = hashInfo['description'];
  }

  @override
  void initState() {
    super.initState();
    isEditing = widget.hashId == null ? false : true;

    time = '${presentDateTime.hour}:${presentDateTime.minute}';
    presentDate = DateTime(
            presentDateTime.year, presentDateTime.month, presentDateTime.day)
        .toString();

    hashInfo['time'] = time;
    hashInfo['hash_date'] = presentDate;
    getData();
  }

  void getData() async {
    _isLoading = true;
    if (_isDataFetched == false) {
      await _fetchHasher();

      if (widget.hashId != null) {
        await _fetchHash();
      }
    }
    setState(() {
      _isLoading = false;
    });
    _isDataFetched = true;
  }

  MyTextField get _displayTitle {
    return MyTextField(
      lableText: 'Hash title',
      controller: _titleController,
      onSaved: (String? value) {
        hashInfo['title'] = value;
        return null;
      },
      validator: (String? value) {
        if (value == null || value.isEmpty) {
          return 'Hash Name is mandatory';
        }
        return null;
      },
    );
  }

  MyTextField get _displayHashNumber {
    return MyTextField(
      lableText: 'Hash Number',
      controller: _hashNumberController,
      onSaved: (String? value) {
        hashInfo['hash_number'] = value;
        return null;
      },
      validator: (String? value) {
        if (value == null || value.isEmpty) {
          return 'Hash number is mandatory';
        }
        return null;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // print('lengthsynch of BannerImage' + '${bannerImage!.lengthSync()}');
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0XFF006B60),
        title:
            isEditing ? const Text('Update Hash') : const Text('Create Hash'),
      ),
      body: SafeArea(
        child: (_isLoading == true)
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
                child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        child: _displayTitle,
                      ),
                      const SizedBox(
                        height: 18,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: _displayHashNumber,
                          ),
                          const SizedBox(
                            width: 8,
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 18,
                      ),
                      Row(
                        children: [
                          SizedBox(
                            width: (MediaQuery.of(context).size.width - 60) / 2,
                            child: Container(
                              width: MediaQuery.of(context).size.width,
                              alignment: Alignment.centerLeft,
                              decoration: BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(color: Colors.grey),
                                ),
                              ),
                              child: TextButton(
                                onPressed: () {
                                  DatePicker.showDatePicker(context,
                                      showTitleActions: true,
                                      minTime: DateTime(1950, 1, 1),
                                      maxTime: DateTime(2022, 12, 30),
                                      onChanged: (date) {
                                    setState(() {
                                      _date = date.toString().split(" ")[0];
                                      hashInfo['hash_date'] = _date;
                                    });
                                  }, onConfirm: (date) {
                                    setState(() {
                                      _date = date.toString().split(" ")[0];
                                      hashInfo['hash_date'] = _date;
                                    });
                                  },
                                      currentTime: DateTime.now(),
                                      locale: LocaleType.en);
                                },
                                child: Text(
                                  _date,
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey.withOpacity(0.5),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          SizedBox(
                            // width: 165,
                            width: (MediaQuery.of(context).size.width - 60) / 2,
                            child: Container(
                              width: MediaQuery.of(context).size.width,
                              // height: 60,
                              alignment: Alignment.centerLeft,
                              decoration: BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(color: Colors.grey),
                                ),
                              ),
                              child: TextButton(
                                onPressed: () async {
                                  TimeOfDay _newTime = await showTimePicker(
                                          context: context,
                                          initialTime:
                                              TimeOfDay(hour: 14, minute: 00),
                                          initialEntryMode:
                                              TimePickerEntryMode.dial) ??
                                      _hashTime;

                                  hashInfo['time'] =
                                      '${_hashTime.format(context)}';
                                  setState(() {
                                    _hashTime = _newTime;
                                  });
                                },
                                child: Text(
                                  '${_hashTime.format(context)}',
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey.withOpacity(0.5),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 18,
                      ),
                      MyTextField(
                        lableText: 'Hash Location',
                        controller: _locationController,
                        onSaved: (String? value) {
                          hashInfo['hash_location'] = value;
                          return null;
                        },
                        validator: (String? value) {
                          if (value == null || value.isEmpty) {
                            return 'Location is mandatory';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(
                        height: 18,
                      ),
                      Row(
                        children: [
                          SizedBox(
                            width: (MediaQuery.of(context).size.width - 60) / 2,
                            child: MyTextField(
                              lableText: 'Starting Point',
                              controller: _startingPointController,
                              onSaved: (String? value) {
                                hashInfo['starting_point'] = value;
                                return null;
                              },
                              validator: (String? value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please provide starting location';
                                }
                                return null;
                              },
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          SizedBox(
                            // width: 165,
                            width: (MediaQuery.of(context).size.width - 60) / 2,
                            child: MyTextField(
                              lableText: 'Ending Point',
                              controller: _endingPointController,
                              onSaved: (String? value) {
                                hashInfo['ending_point'] = value;
                                return null;
                              },
                              validator: (String? value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please provide ending location';
                                }
                                return null;
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 18,
                      ),
                      MyTextField(
                        lableText: 'Special Occasion',
                        controller: _specialOccasionController,
                        onSaved: (String? value) {
                          hashInfo['special_occasion'] = value;
                          return null;
                        },
                      ),
                      const SizedBox(
                        height: 18,
                      ),
                      MyTextField(
                        lableText: 'Hash Description',
                        controller: _descriptionController,
                        maxLine: 5,
                        onSaved: (String? value) {
                          hashInfo['description'] = value;
                          return null;
                        },
                        validator: (String? value) {
                          if (value == null || value.isEmpty) {
                            return 'Please provide short notes on Hash';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(
                        height: 18,
                      ),
                      // Container(
                      //   child: Row(
                      //     children: [
                      //       Text('Hares'),
                      //       SizedBox(
                      //         width: 225,
                      //       ),
                      //       Text(
                      //         'Add more',
                      //         style: TextStyle(fontSize: 10, color: Color(0XFF959595)),
                      //       ),
                      //     ],
                      //   ),
                      // ),
                      // SizedBox(
                      //   height: 32,
                      // ),
                      MultiSelectDialogField(
                        searchable: true,
                        items: _items,
                        initialValue: _selectedHares,
                        title: const Text("Select Hares"),
                        selectedColor: const Color(0XFF006B60),

                        // decoration: BoxDecoration(
                        //     color: Colors.blue.withOpacity(0.1),
                        //     borderRadius: BorderRadius.all(Radius.circular(40)),
                        //     border: Border.all(
                        //       color: Colors.blue,
                        //       width: 2,
                        //     ),
                        // ),
                        buttonIcon: Icon(
                          Icons.pets,
                          color: Colors.grey.withOpacity(0.5),
                        ),
                        buttonText: const Text(
                          "Select Hares",
                          // style: TextStyle(
                          //   color: Colors.blue[800],
                          //   fontSize: 16,
                          // ),
                        ),
                        onConfirm: (result) {
                          hashInfo['hare_list[]'] = result;
                          debugPrint('hasher list selected');
                          debugPrint(hashInfo['hare_list[]'].toString());
                        },
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Text(
                        'Upload banner image',
                        style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey.withOpacity(0.5),
                            fontWeight: FontWeight.w400),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      InkWell(
                        onTap: () async {
                          File? file = await FileService.pickImage(
                              src: ImageSource.gallery);

                          if (file != null) {
                            print('File from repo: $file');
                            print('Filepath in repo:  ${file.path}');
                            setState(() {
                              bannerImage = file;
                              print(bannerImage!.lengthSync());
                              // hashInfo['banner_image'] = file;
                            });
                          } else {
                            bannerImage = null;
                          }
                        },
                        child: Center(
                          child: Column(
                            children: [
                              Icon(
                                Icons.add_a_photo,
                                size: 40,
                                color: Colors.grey.withOpacity(0.7),
                              ),
                              const SizedBox(
                                height: 8,
                              ),
                              Text(
                                'Upload your photo here',
                                style: TextStyle(
                                  color: Colors.grey.withOpacity(0.7),
                                ),
                              ),
                              const SizedBox(
                                height: 18,
                              ),
                              bannerImage != null
                                  ? Image.file(bannerImage!)
                                  : const Text(''),
                            ],
                          ),
                          // SizedBox(height: 20),
                        ),
                      ),
                      const SizedBox(
                        height: 32,
                      ),
                      Center(
                        child: ElevatedButton(
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              _formKey.currentState!.save();
                              var result;
                              // debugPrint(hashInfo.toString());
                              if (bannerImage != null) {
                                debugPrint('Banner Image is not null');
                              } else {
                                debugPrint('Banner Image is null');
                              }

                              debugPrint('hare list from add_hash:');
                              if (hashInfo['hare_list[]'] == null) {
                                debugPrint('HashInfo : Harelist is null');
                              } else {
                                debugPrint(hashInfo['hare_list[]'].toString());
                              }

                              // print(hashInfo.toString());
                              result =
                                  await hr.updateHash(hashInfo, bannerImage);

                              String message = result['message'];
                              // result['success'] = false;
                              if (result['success'] == true) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text(message)),
                                  // SnackBar(content: Text("Test message")),
                                );
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => HashList()),
                                );
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text(message)),
                                  // SnackBar(content: Text("Test Message")),
                                );
                              }
                            }
                          },
                          style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.all(10),
                              fixedSize:
                                  Size(MediaQuery.of(context).size.width, 50),
                              primary: const Color(0XFF006B60),
                              shape: const RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(12)),
                              )),
                          child: const Text(
                            'Save',
                            style: TextStyle(fontSize: 18),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              )),
      ),
    );
  }
}
