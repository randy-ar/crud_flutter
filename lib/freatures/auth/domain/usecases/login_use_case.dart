import 'package:crud_product/core/error/failures.dart';
import 'package:crud_product/core/usecase/usecase.dart';
import 'package:crud_product/freatures/auth/domain/entities/auth_entity.dart';
import 'package:crud_product/freatures/auth/domain/repositories/auth_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

class LoginParams extends Equatable {
  final String name;
  final String password;
  final String deviceName;

  const LoginParams({
    required this.name,
    required this.password,
    required this.deviceName,
  });

  @override
  List<Object?> get props => [name, password, deviceName];
}

class LoginUsecase implements UseCase<AuthEntity, LoginParams> {
  final AuthRepository authRepository;

  const LoginUsecase(this.authRepository);

  @override
  Future<Either<Failure, AuthEntity>> call(LoginParams params) async {
    return authRepository.login(
      name: params.name,
      password: params.password,
      deviceName: params.deviceName,
    );
  }
}
