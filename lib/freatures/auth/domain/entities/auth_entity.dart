import 'package:equatable/equatable.dart';

class AuthEntity extends Equatable {
  final String session;
  final String message;
  final String token;

  const AuthEntity({
    required this.session,
    required this.message,
    required this.token,
  });

  @override
  List<Object?> get props => [session, message, token];
}
