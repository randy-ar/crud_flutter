import 'package:crud_product/core/error/failures.dart';
import 'package:crud_product/core/usecase/usecase.dart';
import 'package:crud_product/freatures/auth/domain/entities/auth_entity.dart';
import 'package:crud_product/freatures/auth/domain/repositories/auth_repository.dart';
import 'package:dartz/dartz.dart';

class LogoutUsecase implements UseCase<AuthEntity, NoParams> {
  final AuthRepository authRepository;

  const LogoutUsecase(this.authRepository);

  @override
  Future<Either<Failure, AuthEntity>> call(NoParams params) async {
    return authRepository.logout();
  }
}
