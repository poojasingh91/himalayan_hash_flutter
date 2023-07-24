import 'package:dio/dio.dart' as dios;
import 'package:flutter/cupertino.dart';

class NetworkService {
  static final dios.Dio _dio = dios.Dio();
  // DioClient dc = GetIt.I<DioClient>();
  // static final DioClient _dc = DioClient();

  // dios.Dio _dio = _dc.dio;
  // static final dios.Dio _dio = _dc.dio;

  // dios.Dio _dio = DioClient();

  static const String baseUrl = 'http://10.0.2.2:8000/api/';

  static Future<dios.Response?> get(
      {required String endPoint, dios.Options? options}) async {
    try {
      dios.Response response = await _dio.get(
        baseUrl + endPoint,
        options: options,
      );

      return response;
    } catch (e) {
      debugPrint(e.toString());
      throw Exception('Failed to get records');
    }
  }

  static Future<dios.Response> post(
      {required String endPoint,
      required dynamic data,
      dios.Options? options}) async {
    try {
      dios.Response response = await _dio.post(
        baseUrl + endPoint,
        data: data,
        options: options,
      );
      debugPrint(response.toString());

      return response;
    } catch (e) {
      debugPrint(e.toString());
      throw Exception('Failed to add record');
    }
  }

  static Future<dios.Response> put(
      {required String endPoint,
      required dynamic data,
      dios.Options? options}) async {
    try {
      dios.Response response = await _dio.put(
        baseUrl + endPoint,
        data: data,
        options: options,
      );
      return response;
    } catch (e) {
      debugPrint(e.toString());
      throw Exception('Failed to update record');
    }
  }

  static Future<dios.Response> delete(
      {required String endPoint, dios.Options? options}) async {
    try {
      dios.Response response = await _dio.delete(
        baseUrl + endPoint,
        options: options,
      );
      return response;
    } catch (e) {
      debugPrint(e.toString());
      throw Exception('Failed to delete record');
    }
  }
}
