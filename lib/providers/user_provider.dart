import 'package:flutter/material.dart';
import '../models/hasher_model.dart';

class LoginProvider with ChangeNotifier {
  String bearerToken = '';

  late Hasher _hasher = Hasher();
  bool isLoading = false;

  setBearerToken(String token) {
    bearerToken = token;
    notifyListeners();
  }

  setLoading(bool value) {
    isLoading = value;
    notifyListeners();
  }

  setUser(Hasher h) {
    _hasher = h;
    notifyListeners();
  }
}
