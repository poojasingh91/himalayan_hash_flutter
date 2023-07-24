import '/models/hasher_model.dart';
import '../models/hashhasher_model.dart';
import '../services/dio_client.dart';
import 'package:dio/dio.dart' as dios;
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:get_it/get_it.dart';

class HashHasherRepository {
  final DioClient dc = GetIt.I<DioClient>();
  // SharedPreferenceHelper sharedPrefLocator = GetIt.I<SharedPreferenceHelper>();

  Future<HashHashers> getHashHasherList() async {
    late HashHashers hs;
    try {
      Response? response = await dc.get(
        endPoint: 'hashhashers',
      );

      if (response != null) {
        hs = HashHashers.fromJson(response.data);
      }
      return hs;
    } on DioError catch (e) {
      debugPrint('Error from Hasher repo ${e.message}');
      throw Exception('Failed to get Hasher List');
    }
  }

  Future<HashersByHashId> getHashersByHash(int hashId) async {
    late HashersByHashId hhi;
    try {
      Response? response = await dc.get(endPoint: 'getHashersByHash/$hashId');

      if (response != null) {
        hhi = HashersByHashId.fromJson(response.data);
      }
      return hhi;
    } on DioError catch (e) {
      debugPrint('Error from getHashersByHash repo ${e.message}');
      throw Exception('Failed to get Hasher by Hash ID');
    }
  }

  Future<List<Hasher>> getUnassignedList(int hashId) async {
    var hasherList = <Hasher>[];
    try {
      Response? response = await dc.get(
        endPoint: 'unassignedhashers/$hashId',
      );

      if (response != null) {
        for (var i in response.data['assignedhashers']) {
          hasherList.add(Hasher.fromJson(i));
        }
      }
      return hasherList;
    } on DioError catch (e) {
      debugPrint('Error from UnassignedHasher repo ${e.message}');
      throw Exception('Failed to get UnassignedHasher List');
    }
  }

  Future<dynamic> getAssignedList(Map<String, dynamic> hashHasherData) async {
    Map<String, dynamic> result;

    try {
      dios.FormData formData = dios.FormData.fromMap({
        'hash_id': hashHasherData['hash_id'],
        'hasher_id': hashHasherData['hasher_id'],
        'is_hare': hashHasherData['is_hare'],
      });
      debugPrint('Form data in HashHasher repo');
      debugPrint(formData.toString());
      Response? response;
      debugPrint('Hasher ID in HashHasher repo');
      debugPrint(hashHasherData['id'].toString());

      if (hashHasherData.containsKey('id')) {
        int hashhasherId = hashHasherData['hash_id'];
        //  ASSIGN HASHER
        response = await dc.post(
            endPoint: "getHashersByHash/$hashhasherId", data: formData);
      }

      if (response != null) {
        result = {
          "success": true,
          "message": "Hasher assigned successfully",
          "data": response.data
        };
      } else {
        result = {
          "success": false,
          "message": "Null value returned while assigning hasher",
          "data": response!.data
        };
        // debugPrint('Null value returned while assigning hasher');
      }

      return result;
    } on DioError catch (e) {
      debugPrint(e.message);
      debugPrint('Failed to assign hasher information');
      result = {"success": false, "message": e.message, "data": ""};
      return result;
    }
  }

  Future<dynamic> updateHashHasher(Map<String, dynamic> hashHasherData) async {
    Map<String, dynamic> result;

    try {
      dios.FormData formData = dios.FormData.fromMap({
        'hash_id': hashHasherData['hash_id'],
        'hasher_id': hashHasherData['hasher_id'],
        'is_hare': hashHasherData['is_hare'],
      });
      debugPrint('Form data in Hasher repo');
      debugPrint(formData.toString());
      Response? response;
      debugPrint('Hasher ID in Hasher repo');
      debugPrint(hashHasherData['id'].toString());

      if (!hashHasherData.containsKey('id')) {
        // CREATE NEW HASHER
        response = await dc.post(endPoint: "hashhashers", data: formData);
      } else {
        int hashhasherId = hashHasherData['id'];
        //  UPDATE HASHER
        response = await dc.post(
            endPoint: "hashhashers/$hashhasherId", data: formData);
      }

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

  Future<dynamic> addHashersToHash(Map<String, dynamic> hashHasherInfo) async {
    Map<String, dynamic> result;
    try {
      dios.FormData formData;
      formData = dios.FormData.fromMap({
        "hash_id": hashHasherInfo["hash_id"],
        "hasher_id[]": hashHasherInfo["hasher_id[]"],
      });

      Response response = await dc.post(endPoint: "addHasher", data: formData);
      if (response != null) {
        result = {
          "success": true,
          "message": "Hashers added to Hash succesfully",
          "data": response.data
        };
      } else {
        result = {
          "success": false,
          "message": "Null value returned while updating hasher",
          "data": response.data
        };
      }

      return result;
    } on DioError catch (e) {
      debugPrint(e.message);
      debugPrint('Failed to add hasher to hash');
      result = {"success": false, "message": e.message, "data": ""};
      return result;
    }
  }

  Future<dynamic> deleteHasher(int hashhasherId) async {
    Map<String, dynamic> result;
    try {
      Response response =
          await dc.delete(endPoint: "hashhashers/$hashhasherId");

      if (response != null) {
        result = {
          "success": true,
          "message": "Hasher deleted successfully",
          "data": response.data
        };
      } else {
        result = {
          "success": false,
          "message": "Null value returned while deleting hasher",
          "data": response.data
        };
        // debugPrint('Null value returned while updating hasher');
      }
      return result;
    } on DioError catch (e) {
      debugPrint(e.message);
      debugPrint('Failed to delete hasher information');
      result = {"success": false, "message": e.message, "data": ""};
      return result;
    }
  }
}
