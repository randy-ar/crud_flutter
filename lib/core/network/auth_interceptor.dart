import 'package:crud_product/core/local_storage/local_storage_service.dart';
import 'package:dio/dio.dart';
import 'package:logger/logger.dart';

class AuthInterceptor extends Interceptor {
  final LocalStorageService localStorageService;

  AuthInterceptor(this.localStorageService);

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    options.headers['Accept'] = 'application/json';
    Logger().d("onRequest");
    Logger().d(options.headers.toString());
    Logger().d(options.uri);
    Logger().d(options.method);
    Logger().d(options.data.toString());
    if (options.data is FormData) {
      final formData = options.data as FormData;
      Logger().d("FormData");
      Logger().d(formData.fields.toString());
      Logger().d(formData.files.toString());
    }
    final token = await localStorageService.getToken();
    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    super.onRequest(options, handler);
  }

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    if (err.response?.statusCode == 401) {
      await localStorageService.deleteToken();
    }
    return handler.next(err);
  }

  @override
  Future<void> onResponse(
    Response response,
    ResponseInterceptorHandler handler,
  ) async {
    Logger().d("onResponse");
    Logger().d(response.data.toString());
    super.onResponse(response, handler);
  }
}
