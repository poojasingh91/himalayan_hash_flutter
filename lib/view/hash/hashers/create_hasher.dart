import 'dart:io';

import 'package:create_hash_ui/models/hasher_model.dart';
import 'package:create_hash_ui/providers/hasher_provider.dart';
import 'package:create_hash_ui/repository/hasher_repository.dart';
import 'package:create_hash_ui/utils/validation.dart';
import 'package:create_hash_ui/models/hasher_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:provider/provider.dart';

import '../../../utils/country_list.dart';
import '../../../widget/MyBottomNavBar.dart';
import '../../../widget/common_textfield.dart';

class CreateHasher extends StatefulWidget {
  final Hasher? hasher;
  const CreateHasher({
    Key? key,
    @required this.hasher,
  }) : super(key: key);

  @override
  State<CreateHasher> createState() => _CreateHasherState();
}

class _CreateHasherState extends State<CreateHasher> {
  bool _isLoading = true;
  String _date = "Date of first Nepal Hash";
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController? countryIdController = TextEditingController();
  final TextEditingController hashesToDateController = TextEditingController();
  final TextEditingController hashesHaredController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  String selectedCountry = 'US';

  late List<Map<String, String>> _countries = [];

  @override
  void initState() {
    _countries = CountryList.getCountryList();
    super.initState();
    _updateHasher();
  }

  load(bool val) {
    if (mounted) {
      setState(() {
        _isLoading = val;
      });
    }
  }

  _updateHasher() {
    if (widget.hasher != null) {
      firstNameController!.text = widget.hasher!.firstName!;
      lastNameController!.text = widget.hasher!.lastName!;
      countryIdController!.text = widget.hasher!.countryId!;
      selectedCountry = widget.hasher!.countryId!;

      _date = widget.hasher!.dateOfFirstNepalHash!;
      hashesToDateController!.text = "${widget.hasher!.noOfHashesToDate!}";
      hashesHaredController!.text = "${widget.hasher!.noOfHashesHared!}";
    }
  }

  MyTextField get _displayFirstName {
    return MyTextField(
      lableText: 'First Name',
      controller: firstNameController,
      onSaved: (String? value) {
        return null;
      },
      validator: (String? value) {
        if (value == null || value.isEmpty) {
          return 'First Name is mandatory';
        }
        return null;
      },
    );
  }

  MyTextField get _displayLastName {
    return MyTextField(
      lableText: 'Last Name',
      controller: lastNameController,
      onSaved: (String? value) {
        return null;
      },
      validator: (String? value) {
        if (value == null || value.isEmpty) {
          return 'Last Name is mandatory';
        }
        return null;
      },
    );
  }

  MyTextField get _displayNoOfHashes {
    return MyTextField(
      lableText: 'No of hashes till date',
      controller: hashesToDateController,
      onSaved: (String? value) {
        return null;
      },
      validator: (String? value) {
        if (value == null || value.isEmpty) {
          return 'No. of hashes till date field is mandatory';
        }
        return null;
      },
      keyboardType: TextInputType.number,
    );
  }

  MyTextField get _displayNoOfHashesHared {
    return MyTextField(
      lableText: 'No of hashes hared',
      controller: hashesHaredController,
      onSaved: (String? value) {
        return null;
      },
      validator: (String? value) {
        if (value == null || value.isEmpty) {
          return 'No. of hashes hared field is mandatory';
        }
        return null;
      },
      keyboardType: TextInputType.number,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Create Hasher',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
        ),
        backgroundColor: const Color.fromARGB(255, 33, 68, 51),
        // toolbarHeight: 82,
      ),
      body: SingleChildScrollView(
          child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 8,
              ),
              Container(
                child: _displayFirstName,
              ),
              SizedBox(
                height: 18,
              ),
              Container(
                child: _displayLastName,
              ),
              SizedBox(
                height: 18,
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                alignment: Alignment.centerLeft,
                child: DropdownButton(
                    isExpanded: true,
                    value: selectedCountry,
                    items: _countries.map((e) {
                      return DropdownMenuItem(
                          child: Text(e['name'] ?? ''), value: e['code']);
                    }).toList(),
                    onChanged: (String? newValue) {
                      print(newValue);
                      setState(() {
                        selectedCountry = newValue!;
                      });
                    }),
              ),
              SizedBox(
                height: 18,
              ),
              SizedBox(
                height: 18,
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                // height: 60,
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
                          maxTime: DateTime(2055, 12, 30), onChanged: (date) {
                        setState(() {
                          _date = date.toString().split(" ")[0];
                        });
                      }, onConfirm: (date) {
                        setState(() {
                          _date = date.toString().split(" ")[0];
                        });
                      }, currentTime: DateTime.now(), locale: LocaleType.en);
                    },
                    child: Text(
                      _date,
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey.withOpacity(0.5),
                      ),
                    )),
              ),
              SizedBox(
                height: 18,
              ),
              Row(
                children: [
                  Expanded(
                    child: _displayNoOfHashes,
                  ),
                  SizedBox(
                    width: 12,
                  ),
                  Expanded(
                    child: _displayNoOfHashesHared,
                  ),
                ],
              ),
              SizedBox(
                height: 42,
              ),
              Center(
                child: ElevatedButton(
                  child: Text(
                    widget.hasher != null ? 'Update' : 'Save',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
                  ),
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      Map<String, dynamic> myMap = <String, dynamic>{};
                      if (widget.hasher != null) {
                        myMap = {
                          "id": widget.hasher!.id!,
                          "first_name": firstNameController!.text,
                          'last_name': lastNameController!.text,
                          'country_id': selectedCountry,
                          // countryIdController!.text,
                          'date_of_first_nepal_hash': _date,
                          'no_of_hashes_to_date': hashesToDateController!.text,
                          'no_of_hashes_hared': hashesHaredController!.text,
                        };
                      } else {
                        myMap = {
                          "first_name": firstNameController!.text,
                          'last_name': lastNameController!.text,
                          // 'country_id': countryIdController!.text,
                          'country_id': selectedCountry,
                          'date_of_first_nepal_hash': _date,
                          'no_of_hashes_to_date': hashesToDateController!.text,
                          'no_of_hashes_hared': hashesHaredController!.text,
                        };
                      }

                      HasherRepository createHasherObj = HasherRepository();
                      var result = await createHasherObj.updateHasher(myMap);

                      if (widget.hasher != null) {
                        Hasher hs = Hasher(
                          id: myMap['id'],
                          firstName: myMap['first_name'],
                          lastName: myMap['last_name'],
                          countryId: myMap['country_id'],
                          dateOfFirstNepalHash:
                              myMap['date_of_first_nepal_hash'],
                          noOfHashesHared:
                              int.parse(myMap['no_of_hashes_to_date']),
                          noOfHashesToDate:
                              int.parse(myMap['no_of_hashes_hared']),
                        );

                        Provider.of<HasherProvider>(context, listen: false)
                            .updateHasher(hs);
                      } else {
                        myMap['id'] = result['data']['id'];
                        Hasher hs = Hasher(
                          id: myMap['id'],
                          firstName: myMap['first_name'],
                          lastName: myMap['last_name'],
                          countryId: myMap['country_id'],
                          dateOfFirstNepalHash:
                              myMap['date_of_first_nepal_hash'],
                          noOfHashesHared:
                              int.parse(myMap['no_of_hashes_to_date']),
                          noOfHashesToDate:
                              int.parse(myMap['no_of_hashes_hared']),
                        );

                        Provider.of<HasherProvider>(context, listen: false)
                            .createHasher(hs);
                      }
                      print('New hasher map');

                      print(myMap.toString());

                      // Add hasher in provider.

                      final snackBar = SnackBar(
                        content: Text(
                          result['data']['message'].toString(),
                          style: TextStyle(color: Colors.green),
                        ),
                      );
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      Navigator.pop(context, result['success'] as bool);
                    }

                    // Find the ScaffoldMessenger in the widget tree
                    // and use it to show a SnackBar.
                    else {
                      final snackbar =
                          SnackBar(content: const Text('Invalid Data'));
                      ScaffoldMessenger.of(context).showSnackBar(snackbar);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.all(20),
                      fixedSize: Size(235, 55),
                      primary: Color(0XFF006B60),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(12)),
                      )),
                ),
              )
            ],
          ),
        ),
      )),
      bottomNavigationBar: MyBottomNavBar(),
    );
  }
}
