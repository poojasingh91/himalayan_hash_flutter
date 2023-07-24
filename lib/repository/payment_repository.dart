import 'dart:convert';
import 'dart:developer';
import '/models/payment_model.dart';
import '/services/dio_client.dart';
import 'package:dio/dio.dart' as dios;
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:get_it/get_it.dart';

class PaymentRepository {
  final DioClient dc = GetIt.I<DioClient>();
  // SharedPreferenceHelper sharedPrefLocator = GetIt.I<SharedPreferenceHelper>();

  Future<Payments> getPaymentList() async {
    late Payments ps;
    try {
      Response? response = await dc.get(
        endPoint: 'feepayments',
      );

      if (response!.statusCode == 200) {
        ps = Payments.fromJson(json.decode(json.encode(response.data)));
      }
      return ps;
    } on DioError catch (e) {
      debugPrint('Error from Payment repo ${e.message}');
      throw Exception('Failed to get Payment List');
    }
  }

  Future<List<HasherPayment>> getToggledData(int hashId) async {
    var hasherPaymentList = <HasherPayment>[];
    try {
      Response? response = await dc.get(
        endPoint: 'feepaymentwithhashid/$hashId',
      );

      if (response!.statusCode! < 400) {
        for (var i in response.data['message']) {
          hasherPaymentList.add(HasherPayment.fromJson(i));
        }
      }
      return hasherPaymentList;
    } on DioError catch (e) {
      debugPrint('Error from Payment repo ${e.message}');
      throw Exception('Failed to get HasherPayment List');
    }
  }

  Future<dynamic> updatePayment(Map<String, dynamic> paymentData) async {
    Map<String, dynamic> result;
    log({
      'hash_id': paymentData['hash_id'],
      'hasher_id[]': paymentData['hasher_id[]'],
      'running_payment_status[]': paymentData['running_payment_status[]'],
      'drink_payment_status[]': paymentData['drink_payment_status[]'],
      'hard_drink_payment_status[]': paymentData['hard_drink_payment_status[]'],
    }.toString());
    try {
      dios.FormData formData = dios.FormData.fromMap({
        'hash_id': paymentData['hash_id'],
        'hasher_id[]': paymentData['hasher_id[]'],
        'running_payment_status[]': paymentData['running_payment_status[]'],
        'drink_payment_status[]': paymentData['drink_payment_status[]'],
        'hard_drink_payment_status[]':
            paymentData['hard_drink_payment_status[]'],
      });

      Response? response;

      response = await dc.post(
          endPoint: "feepayments/${paymentData['hash_id']}", data: formData);

      print("--------------myresponse-----" + response!.data.toString());
      if (response.statusCode! < 400) {
        result = {
          "success": true,
          "message": "Hasher Payment updated successfully",
          "data": response.data
        };
      } else {
        result = {
          "success": false,
          "message": "Failed to update the payment of hasher",
          "data": response!.data
        };
        // debugPrint('Null value returned while updating payment');
      }

      return result;
    } on DioError catch (e) {
      debugPrint(e.message);
      debugPrint('Failed to add/update payment information');
      result = {"success": false, "message": e.message, "data": ""};
      return result;
    }
  }
}
