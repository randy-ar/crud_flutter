import 'package:crud_product/core/error/failures.dart';
import 'package:crud_product/core/usecase/usecase.dart';
import 'package:crud_product/freatures/product/data/models/product_delete_response_model.dart';
import 'package:crud_product/freatures/product/data/models/product_single_response_model.dart';
import 'package:crud_product/freatures/product/domain/repositories/product_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

class DeleteParam extends Equatable {
  final int id;

  DeleteParam({required this.id});

  @override
  List<Object?> get props => [id];
}

class DeleteProductUsecase
    extends UseCase<ProductDeleteResponseModel, DeleteParam> {
  final ProductRepository productRepository;

  DeleteProductUsecase({required this.productRepository});

  @override
  Future<Either<Failure, ProductDeleteResponseModel>> call(
    DeleteParam params,
  ) async {
    return await productRepository.deleteProduct(params.id);
  }
}
