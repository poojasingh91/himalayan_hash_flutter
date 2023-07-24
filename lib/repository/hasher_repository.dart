import 'dart:convert';
import '/models/hasher_model.dart';
import '/services/dio_client.dart';
import 'package:dio/dio.dart' as dios;
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:get_it/get_it.dart';

class HasherRepository {
  final DioClient dc = GetIt.I<DioClient>();
  // SharedPreferenceHelper sharedPrefLocator = GetIt.I<SharedPreferenceHelper>();

  Future<Hashers> getHasherList() async {
    late Hashers hs;
    try {
      Response? response = await dc.get(
        endPoint: 'hashers',
      );

      if (response != null) {
        hs = Hashers.fromJson(json.decode(json.encode(response.data)));
      }
      return hs;
    } on DioError catch (e) {
      debugPrint('Error from Hasher repo ${e.message}');
      throw Exception('Failed to get Hasher List');
    }
  }

  Future<dynamic> updateHasher(Map<String, dynamic> hasherData) async {
    Map<String, dynamic> result;

    try {
      dios.FormData formData = dios.FormData.fromMap({
        'first_name': hasherData['first_name'],
        'last_name': hasherData['last_name'],
        'country_id': hasherData['country_id'],
        'date_of_first_nepal_hash': hasherData['date_of_first_nepal_hash'],
        'no_of_hashes_to_date': hasherData['no_of_hashes_to_date'],
        'no_of_hashes_hared': hasherData['no_of_hashes_hared'],
      });
      debugPrint('Form data in Hasher repo');
      debugPrint(formData.toString());
      Response? response;
      debugPrint('Hasher ID in Hasher repo');
      debugPrint(hasherData['id'].toString());

      if (!hasherData.containsKey('id')) {
        // CREATE NEW HASHER
        response = await dc.post(endPoint: "hashers", data: formData);
      } else {
        int hasherId = hasherData['id'];
        //  UPDATE HASHER
        response = await dc.post(endPoint: "hashers/$hasherId", data: formData);
      }

      // debugPrint('hasher data in hasher repository:');
      // debugPrint(response.data.toString());

      if (response != null) {
        result = {
          "success": true,
          "message": "New Hasher created successfully",
          "data": response.data
        };
      } else {
        result = {
          "success": false,
          "message": "Null value returned while updating hasher",
          "data": response.data
        };
        // debugPrint('Null value returned while updating hasher');
      }

      return result;
    } on DioError catch (e) {
      debugPrint(e.message);
      debugPrint('Failed to add/update hasher information');
      result = {"success": false, "message": e.message, "data": ""};
      return result;
    }
  }

  Future<dynamic> deleteHasher(int hasherId) async {
    var result;
    // int hasherId = 0;

    try {
      // dios.FormData formData = dios.FormData.fromMap({'id': hasherData['id']});
      // hasherId = hasherData['id'];
      Response response = await dc.delete(endPoint: "hashers/$hasherId");

      if (response != null) {
        result = {
          "success": true,
          "message": "Hasher deleted successfully",
          "data": response.data
        };
      } else {
        result = {
          "success": false,
          "message": "Unable to delete hasher.",
          "data": response.data
        };
        // debugPrint('Null value returned while updating hasher');
      }
    } on DioError catch (e) {
      debugPrint(e.message);
      debugPrint('Failed to delete hasher information');
      result = {"success": false, "message": e.message, "data": ""};
      return result;
    }
    return result;
  }
}
