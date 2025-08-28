import 'package:crud_product/freatures/product/data/models/product_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'product_list_response_model.g.dart';

@JsonSerializable()
class ProductListResponseModel {
  @JsonKey(name: 'message')
  final String? message;
  @JsonKey(name: 'session')
  final String? session;
  @JsonKey(name: 'data')
  final List<ProductModel> data;

  const ProductListResponseModel({
    this.message,
    this.session,
    required this.data,
  });

  factory ProductListResponseModel.fromJson(Map<String, dynamic> json) =>
      _$ProductListResponseModelFromJson(json);

  Map<String, dynamic> toJson() => _$ProductListResponseModelToJson(this);
}
