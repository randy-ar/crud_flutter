// lib/features/product/data/datasources/product_remote_data_source.dart

import 'package:crud_product/freatures/product/data/models/product_delete_response_model.dart';
import 'package:crud_product/freatures/product/data/models/product_list_response_model.dart';
import 'package:crud_product/freatures/product/data/models/product_single_response_model.dart';
import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

part 'product_remote_data_source.g.dart';

@RestApi(baseUrl: "http://192.168.3.169:8000/api")
abstract class ProductRemoteDataSource {
  factory ProductRemoteDataSource(Dio dio, {String baseUrl}) =
      _ProductRemoteDataSource;

  @GET('/products')
  @Header('Accept: application/json')
  Future<ProductListResponseModel> getProducts();

  @MultiPart()
  @Header('Accept: application/json')
  @POST('/products')
  Future<ProductSingleResponseModel> createProduct({
    @Part(name: 'name') required String name,
    @Part(name: 'price') required double price,
    @Part(name: 'description') String? description,
    @Part(name: 'image') MultipartFile? image,
  });

  @MultiPart()
  @Header('Accept: application/json')
  @POST('/products/{id}')
  Future<ProductSingleResponseModel> updateProduct({
    @Path("id") required int id,
    @Part(name: 'name') required String name,
    @Part(name: 'price') required double price,
    @Part(name: 'description') String? description,
    @Part(name: 'image') MultipartFile? image,
  });

  @DELETE('/products/{id}')
  @Header('Accept: application/json')
  Future<ProductDeleteResponseModel> deleteProduct(@Path() int id);
}
