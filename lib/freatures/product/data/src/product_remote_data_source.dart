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
  Future<ProductListResponseModel> getProducts();

  @MultiPart()
  @POST('/products')
  Future<ProductSingleResponseModel> createProduct({
    @Part(name: 'name') required String name,
    @Part(name: 'price') required double price,
    @Part(name: 'description') String? description,
    @Part(name: 'image') MultipartFile? image,
  });

  @MultiPart()
  @PUT('/products/{id}')
  Future<ProductSingleResponseModel> updateProduct({
    @Path() required int id,
    @Path() required String name,
    @Path() required double price,
    @Path() String? description,
    @Path() MultipartFile? image,
  });

  @DELETE('/products/{id}')
  Future<ProductDeleteResponseModel> deleteProduct(@Path() int id);
}
