import 'package:crud_product/freatures/product/data/models/product_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'product_single_response_model.g.dart';

@JsonSerializable()
class ProductSingleResponseModel {
  @JsonKey(name: 'message')
  final String? message;
  @JsonKey(name: 'session')
  final String? session;
  @JsonKey(name: 'data')
  final ProductModel? data;

  const ProductSingleResponseModel({this.message, this.session, this.data});

  factory ProductSingleResponseModel.fromJson(Map<String, dynamic> json) =>
      _$ProductSingleResponseModelFromJson(json);

  Map<String, dynamic> toJson() => _$ProductSingleResponseModelToJson(this);
}
