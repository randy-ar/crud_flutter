import 'package:crud_product/core/error/failures.dart';
import 'package:crud_product/core/usecase/usecase.dart';
import 'package:crud_product/freatures/product/data/models/product_list_response_model.dart';
import 'package:crud_product/freatures/product/domain/repositories/product_repository.dart';
import 'package:dartz/dartz.dart';

class GetProductsUsecase
    implements UseCase<ProductListResponseModel, NoParams> {
  final ProductRepository productRepository;

  GetProductsUsecase({required this.productRepository});

  @override
  Future<Either<Failure, ProductListResponseModel>> call(
    NoParams params,
  ) async {
    return await productRepository.getAllProducts();
  }
}
