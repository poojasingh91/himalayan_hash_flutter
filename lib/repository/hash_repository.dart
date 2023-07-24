import 'dart:io';

import 'package:create_hash_ui/models/hash_model.dart';
import 'package:create_hash_ui/services/dio_client.dart';
import 'package:dio/dio.dart' as dios;
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:get_it/get_it.dart';
import 'package:http_parser/http_parser.dart';

class HashRepository {
  final DioClient dc = GetIt.I<DioClient>();
  // SharedPreferenceHelper sharedPrefLocator = GetIt.I<SharedPreferenceHelper>();

  Future<Hashes> getHashList() async {
    late Hashes hs;
    try {
      Response? response = await dc.get(
        endPoint: 'hashs',
      );

      if (response != null) {
        // debugPrint('Printing Response :');
        // Prepare list of Hash and return it.
        hs = Hashes.fromJson(response.data);
      }
      return hs;
    } on DioError catch (e) {
      debugPrint('Error from Hash repo ${e.message}');
      throw Exception('Failed to get Hash List');
    }
  }

  Future<HashDetail> getHash(int hashId) async {
    // late Hash hash;
    late HashDetail hd;

    try {
      Response? response = await dc.get(endPoint: "hashs/$hashId");

      if (response != null) {
        hd = HashDetail.fromJson(response.data);
      }
      return hd;
    } on DioError catch (e) {
      debugPrint('Error from Hash repo ${e.message}');
      throw Exception('Failed to get Hash');
    }
  }

  Future<dynamic> updateHash(Map<String, dynamic> hashData, File? file) async {
    Map<String, dynamic> result;
    dios.FormData formData;
    debugPrint('Hash data: ');
    debugPrint(hashData.toString());
    try {
      if (file != null) {
        debugPrint('Printing file path in repo: ');
        debugPrint(file.path);
        String fileName = file.path.split('/').last;
        debugPrint('Printing file name $fileName');
        debugPrint('hare list from Repo:');
        debugPrint(hashData['hare_list']);

        formData = dios.FormData.fromMap({
          'title': hashData['title'],
          'hash_number': hashData['hash_number'],
          'hash_date': hashData['hash_date'],
          'time': hashData['time'],
          'hash_location': hashData['hash_location'],
          'starting_point': hashData['starting_point'],
          'ending_point': hashData['ending_point'],
          'special_occasion': hashData['special_occasion'],
          'description': hashData['description'],
          'hare_list[]': hashData['hare_list[]'],
          'banner_image': dios.MultipartFile.fromBytes(file.readAsBytesSync(),
              filename: '${DateTime.now().second}.jpg',
              contentType: MediaType("image", "jpg"))
          // 'banner-image': await MultipartFile.fromFile(
          //   file.path,
          //   filename: fileName,
          //   contentType: MediaType("image", "jpg"),
          // )
        });
      } else {
        formData = dios.FormData.fromMap({
          'title': hashData['title'],
          'hash_number': hashData['hash_number'],
          'hash_date': hashData['hash_date'],
          'time': hashData['time'],
          'hash_location': hashData['hash_location'],
          'starting_point': hashData['starting_point'],
          'ending_point': hashData['ending_point'],
          'special_occasion': hashData['special_occasion'],
          'description': hashData['description'],
          'hare_list[]': hashData['hare_list[]'],
        });
      }

      debugPrint('Form data in Hash repo');
      debugPrint(formData.toString());
      Response? response;
      debugPrint('Hash ID in Hash repo');
      debugPrint(hashData['id'].toString());

      if (hashData['id'] > 0) {
        int hashId = hashData['id'];
        //  UPDATE HASH
        response = await dc.post(
          endPoint: "hashs/$hashId",
          data: formData,
        );
      } else {
        // CREATE NEW HASH
        response = await dc.post(endPoint: "hashs", data: formData);
      }

      if (response != null) {
        debugPrint(response.toString());
        result = {
          "success": true,
          "message": "New Hash created successfully",
          "data": response.data
        };
      } else {
        result = {
          "success": false,
          "message": "Null value returned while updating hash",
          "data": response.data
        };
        // debugPrint('Null value returned while updating hash');
      }

      return result;
    } on DioError catch (e) {
      debugPrint(e.message);
      debugPrint('Failed to add/update hash information');
      result = {"success": false, "message": e.message, "data": ""};
      return result;
    }
  }

  Future<dynamic> deleteHash(Map<String, dynamic> hashData) async {
    Map<String, dynamic> result;
    int hashId = 0;
    try {
      // dios.FormData formData = dios.FormData.fromMap({'id': hashData['id']});
      hashId = hashData['id'];
      Response response = await dc.delete(endPoint: "hashs/$hashId");
      // debugPrint('delete hash from repo: ');
      // debugPrint(response.toString());
      if (response != null) {
        result = {
          "success": true,
          "message": "Hash deleted successfully",
          "data": response.data
        };
      } else {
        result = {
          "success": false,
          "message": "Null value returned while deleting hash",
          "data": response.data
        };
        // debugPrint('Null value returned while updating hash');
      }
      return result;
    } on DioError catch (e) {
      debugPrint(e.message);
      debugPrint('Failed to delete hash information');
      result = {"success": false, "message": e.message, "data": ""};
      return result;
    }
  }
}
