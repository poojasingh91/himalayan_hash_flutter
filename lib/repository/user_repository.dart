import 'package:create_hash_ui/services/dio_client.dart';
import 'package:dio/dio.dart' as dios;
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import '../models/user_model.dart';

class UserRepository {
  final DioClient dc = GetIt.I<DioClient>();

  Future<UserVerification> userLogin(
      {required String userName, required String password}) async {
    late UserVerification uv;
    try {
      var loginData = {"username": userName, "password": password};

      dios.Response response =
          await dc.post(endPoint: 'login', data: loginData);
      debugPrint('Login status');
      debugPrint(response.data.toString());
      debugPrint(response.data['message'].toString());

      if (response != null) {
        if (response.data['message'] == null) {
          user u = user.fromJson(response.data);

          uv = UserVerification(
              usr: response.data['User'],
              success: true,
              msg: "Login successful",
              token: 'Bearer ' + response.data['token']);
        } else {
          uv = UserVerification(
              success: false, msg: response.data['message'], token: "");
        }
      } else {
        uv = UserVerification(success: false, msg: "Login failed", token: "");
      }

      return uv;
    } on dios.Dio catch (e) {
      uv = UserVerification(success: false, msg: "Login failed", token: "");
      debugPrint(e.toString());
      // throw Exception('Problem in user login');
      return uv;
    }
  }
}
