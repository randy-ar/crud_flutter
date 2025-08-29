import 'package:crud_product/core/error/failures.dart';
import 'package:crud_product/core/local_storage/local_storage_service.dart';
import 'package:crud_product/freatures/auth/data/src/auth_remote_data_source.dart';
import 'package:crud_product/freatures/auth/domain/entities/auth_entity.dart';
import 'package:crud_product/freatures/auth/domain/repositories/auth_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:logger/logger.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final LocalStorageService localStorageService;

  const AuthRepositoryImpl(this.remoteDataSource, this.localStorageService);

  @override
  Future<Either<Failure, AuthEntity>> login({
    required String name,
    required String password,
    required String deviceName,
  }) async {
    try {
      final authModel = await remoteDataSource.login(
        name: name,
        password: password,
        deviceName: deviceName,
      );
      await localStorageService.saveToken(authModel.token!);
      return Right(authModel);
    } on DioException catch (e) {
      if (e.response != null && e.response!.statusCode == 422) {
        final data = InputErrorWrapper.fromJson(e.response!.data);
        Logger().e(data.errors);
        return Left(
          InputFailure(
            message: e.message ?? 'Input error',
            data: data,
            statusCode: e.response!.statusCode,
            statusMessage: e.response!.statusMessage,
            requestOptions: e.requestOptions,
          ),
        );
      }
      return Left(ServerFailure(message: e.message ?? 'Unknown error'));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, AuthEntity>> logout() async {
    try {
      // Panggil API logout (opsional, jika server membutuhkan)
      final response = await remoteDataSource.logout();

      // Hapus token dari local storage
      await localStorageService.deleteToken();
      return Right(response);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }
}
