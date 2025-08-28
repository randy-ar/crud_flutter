import 'package:crud_product/core/usecase/usecase.dart';
import 'package:crud_product/freatures/auth/domain/entities/auth_entity.dart';
import 'package:crud_product/core/error/failures.dart';
import 'package:crud_product/freatures/auth/domain/usecases/login_use_case.dart';
import 'package:crud_product/freatures/auth/domain/usecases/logout_use_case.dart';
import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final LoginUsecase loginUsecase;
  final LogoutUsecase logoutUsecase;

  AuthBloc({required this.loginUsecase, required this.logoutUsecase})
    : super(AuthInitial()) {
    on<LoginButtonPressed>(_onLoginButtonPressed);
    on<LogoutButtonPressed>(_onLogoutButton);
  }

  Future<void> _onLoginButtonPressed(
    LoginButtonPressed event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    final result = await loginUsecase.call(
      LoginParams(
        name: event.name,
        password: event.password,
        deviceName: event.deviceName,
      ),
    );
    result.fold((failure) {
      if (failure is InputFailure) {
        // State ini bisa digunakan untuk menampilkan pesan error spesifik di UI
        emit(
          AuthInputError(
            data: failure.data,
            statusCode: failure.statusCode,
            statusMessage: failure.statusMessage,
            requestOptions: failure.requestOptions,
          ),
        );
      } else {
        emit(AuthFailure(message: failure.message));
      }
    }, (authEntity) => emit(AuthSuccess(authEntity: authEntity)));
  }

  Future<void> _onLogoutButton(
    LogoutButtonPressed event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    final result = await logoutUsecase.call(NoParams());
    result.fold(
      (failure) => emit(AuthFailure(message: failure.message)),
      (AuthEntity) => emit(AuthLogoutSuccess(authEntity: AuthEntity)),
    );
  }
}

abstract class AuthEvent extends Equatable {
  const AuthEvent();
  @override
  List<Object> get props => [];
}

class LoginButtonPressed extends AuthEvent {
  final String name;
  final String password;
  final String deviceName;

  const LoginButtonPressed({
    required this.name,
    required this.password,
    required this.deviceName,
  });

  @override
  List<Object> get props => [name, password, deviceName];
}

class LogoutButtonPressed extends AuthEvent {}

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object> get props => [];
}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthSuccess extends AuthState {
  final AuthEntity authEntity;

  const AuthSuccess({required this.authEntity});

  @override
  List<Object> get props => [authEntity];
}

class AuthLogoutSuccess extends AuthState {
  final AuthEntity authEntity;
  const AuthLogoutSuccess({required this.authEntity});

  @override
  List<Object> get props => [authEntity];
}

class AuthInputError extends AuthState {
  final InputErrorWrapper data;
  final int? statusCode;
  final String? statusMessage;
  final RequestOptions requestOptions;

  const AuthInputError({
    required this.data,
    required this.statusCode,
    required this.statusMessage,
    required this.requestOptions,
  });

  @override
  List<Object> get props => [];
}

class AuthFailure extends AuthState {
  final String message;

  const AuthFailure({required this.message});

  @override
  List<Object> get props => [message];
}
