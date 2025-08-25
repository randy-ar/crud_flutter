import 'package:crud_product/core/error/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

// Kelas abstrak untuk UseCase tanpa parameter
abstract class UseCase<Type, Params> {
  Future<Either<Failure, Type>> call(Params params);
}

// Kelas abstrak untuk parameter yang tidak dibutuhkan
class NoParams extends Equatable {
  @override
  List<Object?> get props => [];
}
