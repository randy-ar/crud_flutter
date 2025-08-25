import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  final String message;

  const Failure({required this.message});

  @override
  List<Object> get props => [message];
}

// Kegagalan yang terkait dengan server (misalnya, koneksi terputus, kode status 404, 500)
class ServerFailure extends Failure {
  const ServerFailure({required super.message});
}

// Kegagalan yang terkait dengan data lokal (misalnya, kegagalan saat membaca dari database lokal)
class CacheFailure extends Failure {
  const CacheFailure({required super.message});
}

// Kegagalan yang terkait dengan autentikasi (misalnya, token tidak valid, kredensial salah)
class AuthFailure extends Failure {
  const AuthFailure({required super.message});
}

// Kegagalan yang terkait dengan input (misalnya, validasi data gagal)
class InputFailure extends Failure {
  final InputErrorWrapper data;
  final int? statusCode;
  final String? statusMessage;
  final RequestOptions requestOptions;

  const InputFailure({
    required super.message,
    required this.data,
    required this.statusCode,
    required this.statusMessage,
    required this.requestOptions,
  });
}

class InputErrorWrapper {
  final Map<String, List<dynamic>>? errors;

  InputErrorWrapper({this.errors});

  factory InputErrorWrapper.fromJson(Map<String, dynamic> json) {
    final Map<String, List<dynamic>> errorsMap = {};
    if (json['errors'] != null) {
      (json['errors'] as Map<String, dynamic>).forEach((key, value) {
        if (value is List) {
          errorsMap[key] = value;
        }
      });
    }
    return InputErrorWrapper(errors: errorsMap);
  }
}
