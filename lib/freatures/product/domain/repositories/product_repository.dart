import 'package:crud_product/core/error/failures.dart';
import 'package:crud_product/freatures/product/data/models/product_delete_response_model.dart';
import 'package:crud_product/freatures/product/data/models/product_list_response_model.dart';
import 'package:crud_product/freatures/product/data/models/product_single_response_model.dart';
import 'package:dartz/dartz.dart';

abstract class ProductRepository {
  Future<Either<Failure, ProductListResponseModel>> getAllProducts();
  Future<Either<Failure, ProductSingleResponseModel>> createProduct({
    required String name,
    required double price,
    String? description,
    String? image,
  });

  Future<Either<Failure, ProductSingleResponseModel>> updateProduct({
    required int id,
    required String name,
    required double price,
    String? description,
    String? image,
  });

  Future<Either<Failure, ProductDeleteResponseModel>> deleteProduct(int id);
}
