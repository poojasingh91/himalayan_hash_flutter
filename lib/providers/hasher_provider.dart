import 'package:create_hash_ui/models/hash_model.dart';
import 'package:create_hash_ui/models/hasher_model.dart';
import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../repository/hasher_repository.dart';

class HasherProvider with ChangeNotifier {
  late List<Hasher> _hasherList = [];
  bool isLoading = false;

  List<Hasher> get hasherList => _hasherList;

  setLoading(bool value) {
    isLoading = value;
    notifyListeners();
  }

  Future<List<Hasher>> loadHashers() async {
    print('load hashers() provider function called:');
    Hashers hs;
    isLoading = true;
    HasherRepository hr = HasherRepository();
    hs = await hr.getHasherList();
    _hasherList = hs.getHashers!;
    print('Hasher List count - from Provider');
    print(_hasherList!.length.toString());

    notifyListeners();
    return _hasherList;
  }

  void createHasher(Hasher hasher) {
    //create hasher object
    _hasherList.add(hasher);
    notifyListeners();
  }

  void updateHasher(Hasher hasher) {
    int hasherID = hasher.id!;

    _hasherList.removeWhere((element) => element.id == hasherID);
    _hasherList.add(hasher);

    // print('hasher updated');
    // print(result.toString());
    notifyListeners();
  }

  void removeHasher(int hasherId) {
    print('Remove hasher called with ID: $hasherId');
    _hasherList.removeWhere((element) => element.id == hasherId);
    notifyListeners();
  }
}
