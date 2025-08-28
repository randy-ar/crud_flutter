// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_list_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProductListResponseModel _$ProductListResponseModelFromJson(
  Map<String, dynamic> json,
) => ProductListResponseModel(
  message: json['message'] as String?,
  session: json['session'] as String?,
  data: (json['data'] as List<dynamic>)
      .map((e) => ProductModel.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$ProductListResponseModelToJson(
  ProductListResponseModel instance,
) => <String, dynamic>{
  'message': instance.message,
  'session': instance.session,
  'data': instance.data,
};
