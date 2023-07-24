import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'dio_interceptor.dart';
import 'end_points.dart';

class DioClient {
  final Dio _dio = Dio();
  // _dio.options.ConnectTimeout = EndPoints.connectionTimeout;
  // _dio.options.receiveTimeout = EndPoints.receiveTimeout;

  // String baseUrl = 'http://10.0.2.2:8000/api/';
  String baseUrl = EndPoints.baseUrl;

  DioClient() {
    _dio.interceptors.add(DioInterceptor());
    _dio
      ..options.baseUrl = EndPoints.baseUrl
      ..options.connectTimeout = EndPoints.connectionTimeout
      ..options.receiveTimeout = EndPoints.receiveTimeout;
  }

  Dio get dio => _dio;

  Future<Response?> get({required String endPoint, Options? options}) async {
    try {
      Response response = await _dio.get(
        baseUrl + endPoint,
        options: options,
      );
      debugPrint('Get Records, endPoint: ${baseUrl + endPoint}');
      print(response);
      return response;
    } catch (e) {
      debugPrint(e.toString());
      throw Exception('Failed to get records');
    }
  }

  Future<Response> post(
      {required String endPoint,
      required dynamic data,
      Options? options}) async {
    print(endPoint);
    print(data);
    try {
      Response response = await _dio.post(
        baseUrl + endPoint,
        data: data,
        options: options,
      );

      return response;
    } on DioError catch (e) {
      debugPrint(e.toString());
      throw Exception('Failed to add record');
    } on SocketException catch (e) {
      throw SocketException(e.toString());
    } on FormatException catch (_) {
      throw const FormatException("Unable to process the data");
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  Future<Response> put(
      {required String endPoint,
      required dynamic data,
      Options? options}) async {
    try {
      Response response = await _dio.put(
        baseUrl + endPoint,
        data: data,
        options: options,
      );
      return response;
    } on DioError catch (e) {
      debugPrint(e.toString());
      throw Exception('Failed to update record');
    } on SocketException catch (e) {
      throw SocketException(e.toString());
    } on FormatException catch (_) {
      throw const FormatException("Unable to process the data");
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> delete({required String endPoint, Options? options}) async {
    try {
      Response response = await _dio.delete(
        baseUrl + endPoint,
        options: options,
      );
      return response;
    } on DioError catch (e) {
      debugPrint(e.toString());
      throw Exception('Failed to delete record');
    } on SocketException catch (e) {
      throw SocketException(e.toString());
    } on FormatException catch (_) {
      throw const FormatException("Unable to delete the data");
    } catch (e) {
      rethrow;
    }
  }
}
