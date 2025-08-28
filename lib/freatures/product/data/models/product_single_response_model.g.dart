// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_single_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProductSingleResponseModel _$ProductSingleResponseModelFromJson(
  Map<String, dynamic> json,
) => ProductSingleResponseModel(
  message: json['message'] as String?,
  session: json['session'] as String?,
  data: json['data'] == null
      ? null
      : ProductModel.fromJson(json['data'] as Map<String, dynamic>),
);

Map<String, dynamic> _$ProductSingleResponseModelToJson(
  ProductSingleResponseModel instance,
) => <String, dynamic>{
  'message': instance.message,
  'session': instance.session,
  'data': instance.data,
};
