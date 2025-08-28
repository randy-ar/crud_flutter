import 'package:equatable/equatable.dart';

class AuthEntity extends Equatable {
  final String session;
  final String message;
  final String? token;

  const AuthEntity({required this.session, required this.message, this.token});

  @override
  List<Object?> get props => [session, message, token];
}
