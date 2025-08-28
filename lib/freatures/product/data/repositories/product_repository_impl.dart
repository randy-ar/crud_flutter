import 'package:crud_product/core/error/failures.dart';
import 'package:crud_product/freatures/product/data/models/product_delete_response_model.dart';
import 'package:crud_product/freatures/product/data/models/product_list_response_model.dart';
import 'package:crud_product/freatures/product/data/models/product_single_response_model.dart';
import 'package:crud_product/freatures/product/data/src/product_remote_data_source.dart';
import 'package:crud_product/freatures/product/domain/repositories/product_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:logger/logger.dart';

class ProductRepositoryImpl implements ProductRepository {
  final ProductRemoteDataSource remoteDataSource;

  ProductRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, ProductListResponseModel>> getAllProducts() async {
    try {
      final response = await remoteDataSource.getProducts();
      return Right(response); // Langsung kembalikan objek respons
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, ProductSingleResponseModel>> createProduct({
    required String name,
    required double price,
    String? description,
    String? image, // path file dari file picker
  }) async {
    try {
      MultipartFile? multipartImage;
      if (image != null && image.isNotEmpty) {
        multipartImage = await MultipartFile.fromFile(
          image,
          filename: image.split('/').last,
        );
      }

      final response = await remoteDataSource.createProduct(
        name: name,
        price: price,
        description: description ?? '',
        image: multipartImage,
      );
      Logger().d("Data yang dikirim ke server:");
      Logger().d({
        name: name,
        description: description ?? '',
        price: price,
        image: multipartImage,
      });
      return Right(response);
    } on DioException catch (e) {
      if (e.response != null && e.response!.statusCode == 422) {
        return Left(
          InputFailure(
            message: 'Validation error',
            data: InputErrorWrapper.fromJson(e.response!.data),
            statusCode: e.response!.statusCode,
            statusMessage: e.response!.statusMessage,
            requestOptions: e.requestOptions,
          ),
        );
      }
      return Left(ServerFailure(message: e.toString()));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, ProductSingleResponseModel>> updateProduct({
    required int id,
    required String name,
    required double price,
    String? description,
    String? image,
  }) async {
    try {
      MultipartFile? multipartImage;
      if (image != null && image.isNotEmpty) {
        multipartImage = await MultipartFile.fromFile(
          image,
          filename: image.split('/').last,
        );
      }
      Logger().d("Data yang dikirim ke server:");
      Logger().d({
        "id": id,
        "name": name,
        "description": description ?? '',
        "price": price,
        "image": multipartImage,
      });

      final response = await remoteDataSource.updateProduct(
        id: id,
        name: name,
        price: price,
        description: description ?? '',
        image: multipartImage,
      );

      return Right(response);
    } on DioException catch (e) {
      if (e.response != null && e.response!.statusCode == 422) {
        Logger().d({
          "data": InputErrorWrapper.fromJson(e.response!.data),
          "message": e.message.toString(),
          "statusCode": e.response!.statusCode,
          "statusMessage": e.response!.statusMessage,
          "requestOptions": e.requestOptions,
        });
        Logger().d("Validation error");
        Logger().d(e.response!.data);
        Logger().d({
          "data": InputErrorWrapper.fromJson(e.response!.data),
          "message": e.message.toString(),
          "statusCode": e.response!.statusCode,
          "statusMessage": e.response!.statusMessage,
          "requestOptions": e.requestOptions,
        });
        return Left(
          InputFailure(
            data: InputErrorWrapper.fromJson(e.response!.data),
            message: e.message.toString(),
            statusCode: e.response!.statusCode,
            statusMessage: e.response!.statusMessage,
            requestOptions: e.requestOptions,
          ),
        );
      } else {
        return Left(ServerFailure(message: e.toString()));
      }
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, ProductDeleteResponseModel>> deleteProduct(
    int id,
  ) async {
    try {
      final response = await remoteDataSource.deleteProduct(id);
      return Right(response);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }
}
