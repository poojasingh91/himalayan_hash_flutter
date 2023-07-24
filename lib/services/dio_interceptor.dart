import 'package:create_hash_ui/services/shared_prefernce_help.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';

class DioInterceptor extends Interceptor {
  final _prefsLocator = GetIt.I<SharedPreferenceHelper>();

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    var tok = _prefsLocator.getUserToken();
    options.headers['Authorization'] = _prefsLocator.getUserToken();
    super.onRequest(options, handler);
  }


}
