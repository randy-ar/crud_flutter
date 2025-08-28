import 'package:crud_product/core/usecase/usecase.dart';
import 'package:crud_product/freatures/auth/domain/entities/auth_entity.dart';
import 'package:crud_product/core/error/failures.dart';
import 'package:crud_product/freatures/auth/domain/usecases/login_use_case.dart';
import 'package:crud_product/freatures/auth/domain/usecases/logout_use_case.dart';
import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

class AuthCubit extends Cubit<AuthState> {
  final LoginUsecase loginUsecase;
  final LogoutUsecase logoutUsecase;

  AuthCubit(this.loginUsecase, this.logoutUsecase) : super(AuthInitial());

  Future<void> login({
    required String name,
    required String password,
    required String deviceName,
  }) async {
    emit(AuthLoading());
    final result = await loginUsecase.call(
      LoginParams(name: name, password: password, deviceName: deviceName),
    );
    result.fold(
      (failure) => {
        if (failure is InputFailure)
          {
            emit(
              AuthInputError(
                data: failure.data,
                statusCode: failure.statusCode,
                statusMessage: failure.statusMessage,
                requestOptions: failure.requestOptions,
              ),
            ),
          }
        else
          {emit(AuthFailure(message: failure.message))},
      },
      (result) => emit(AuthSuccess(authEntity: result)),
    );
  }

  Future<void> logout() async {
    emit(AuthLoading());
    final result = await logoutUsecase.call(NoParams());
    result.fold(
      (failure) => emit(AuthFailure(message: failure.message)),
      (result) => emit(AuthLogoutSuccess(authEntity: result)),
    );
  }
}

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
