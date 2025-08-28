import 'package:crud_product/core/error/failures.dart';
import 'package:crud_product/core/usecase/usecase.dart';
import 'package:crud_product/freatures/product/data/models/product_single_response_model.dart';
import 'package:crud_product/freatures/product/domain/repositories/product_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

class CreateParams extends Equatable {
  final String name;
  final double price;
  final String? description;
  final String? image;

  const CreateParams({
    required this.name,
    required this.price,
    this.description,
    this.image,
  });

  @override
  List<Object?> get props => [name, price, description, image];
}

class CreateProductUsecase
    implements UseCase<ProductSingleResponseModel, CreateParams> {
  final ProductRepository productRepository;

  CreateProductUsecase({required this.productRepository});

  @override
  Future<Either<Failure, ProductSingleResponseModel>> call(
    CreateParams params,
  ) async {
    return await productRepository.createProduct(
      name: params.name,
      price: params.price,
      description: params.description,
      image: params.image,
    );
  }
}
