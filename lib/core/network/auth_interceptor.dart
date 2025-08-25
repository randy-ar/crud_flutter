import 'package:crud_product/core/local_storage/local_storage_service.dart';
import 'package:dio/dio.dart';

class AuthInterceptor extends Interceptor {
  final LocalStorageService localStorageService;

  AuthInterceptor(this.localStorageService);

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final token = await localStorageService.getToken();
    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    super.onRequest(options, handler);
  }
}
