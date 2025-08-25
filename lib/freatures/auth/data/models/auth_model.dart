import 'package:crud_product/freatures/auth/domain/entities/auth_entity.dart';
import 'package:json_annotation/json_annotation.dart';

part 'auth_model.g.dart';

@JsonSerializable()
class AuthModel extends AuthEntity {
  const AuthModel({
    required super.session,
    required super.message,
    required super.token,
  });

  factory AuthModel.fromJson(Map<String, dynamic> json) =>
      _$AuthModelFromJson(json);
  Map<String, dynamic> toJson() => _$AuthModelToJson(this);
}
