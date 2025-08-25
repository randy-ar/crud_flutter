import 'package:crud_product/core/error/failures.dart';
import 'package:crud_product/freatures/auth/domain/entities/auth_entity.dart';
import 'package:dartz/dartz.dart';

abstract class AuthRepository {
  Future<Either<Failure, AuthEntity>> login({
    required String name,
    required String password,
    required String deviceName,
  });
}
