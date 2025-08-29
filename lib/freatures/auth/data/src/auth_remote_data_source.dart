import 'package:crud_product/freatures/auth/data/models/auth_model.dart';
import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

part 'auth_remote_data_source.g.dart';

@RestApi(baseUrl: "http://192.168.3.169:8000/api")
abstract class AuthRemoteDataSource {
  factory AuthRemoteDataSource(Dio dio, {String baseUrl}) =
      _AuthRemoteDataSource;

  @POST('/login')
  Future<AuthModel> login({
    @Field('name') required String name,
    @Field('password') required String password,
    @Field('device_name') required String deviceName,
  });

  @POST('/logout')
  Future<AuthModel> logout();
}
