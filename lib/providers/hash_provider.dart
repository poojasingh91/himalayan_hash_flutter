import 'package:flutter/material.dart';
import '../models/hash_model.dart';
import '../repository/hash_repository.dart';

class HashProvider with ChangeNotifier {
  late List<Hash> _hashList = [];
  bool isLoading = false;

  List<Hash> get getHashList => _hashList;
  int get getHashCount => _hashList.length ?? 0;

  setLoading(bool value) {
    isLoading = value;
    notifyListeners();
  }

  Future<List<Hash>> loadHashes() async {
    print('load hashers() provider function called:');
    setLoading(true);

    HashRepository hr = HashRepository();
    var hashes = await hr.getHashList();
    _hashList = hashes.getHashes!;

    print('Hash count - from Hash Provider');
    print(_hashList!.length.toString());

    notifyListeners();
    return _hashList;
  }
}
