import 'package:crud_product/core/error/failures.dart';
import 'package:crud_product/core/usecase/usecase.dart';
import 'package:crud_product/freatures/product/data/models/product_single_response_model.dart';
import 'package:crud_product/freatures/product/domain/repositories/product_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

class UpdateParam extends Equatable {
  final int id;
  final String name;
  final double price;
  final String? description;
  final String? image;

  const UpdateParam({
    required this.id,
    required this.name,
    required this.price,
    this.description,
    this.image,
  });

  @override
  List<Object?> get props => [id, name, price, description, image];
}

class UpdateProductUsecase
    extends UseCase<ProductSingleResponseModel, UpdateParam> {
  final ProductRepository productRepository;

  UpdateProductUsecase({required this.productRepository});

  @override
  Future<Either<Failure, ProductSingleResponseModel>> call(
    UpdateParam params,
  ) async {
    return await productRepository.updateProduct(
      id: params.id,
      name: params.name,
      price: params.price,
      description: params.description,
      image: params.image,
    );
  }
}
