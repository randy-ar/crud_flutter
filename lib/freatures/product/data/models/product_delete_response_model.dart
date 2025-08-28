import 'package:json_annotation/json_annotation.dart';

part 'product_delete_response_model.g.dart';

@JsonSerializable()
class ProductDeleteResponseModel {
  @JsonKey(name: 'message')
  final String? message;
  @JsonKey(name: 'session')
  final String? session;

  ProductDeleteResponseModel({this.message, this.session});

  factory ProductDeleteResponseModel.fromJson(Map<String, dynamic> json) =>
      _$ProductDeleteResponseModelFromJson(json);

  Map<String, dynamic> toJson() => _$ProductDeleteResponseModelToJson(this);
}
