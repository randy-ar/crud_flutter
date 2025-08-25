import 'package:crud_product/core/local_storage/hive_service_impl.dart';
import 'package:crud_product/core/local_storage/local_storage_service.dart';
import 'package:crud_product/core/network/auth_interceptor.dart';
import 'package:crud_product/freatures/auth/presentation/pages/login_page.dart';
import 'package:flutter/material.dart';
import 'package:crud_product/freatures/auth/data/datasources/auth_remote_data_source.dart';
import 'package:crud_product/freatures/auth/data/repositories/auth_repository_impl.dart';
import 'package:crud_product/freatures/auth/domain/repositories/auth_repository.dart';
import 'package:crud_product/freatures/auth/domain/usecases/login_use_case.dart';
import 'package:crud_product/freatures/auth/presentation/bloc/auth_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:dio/dio.dart';
import 'package:hive_flutter/adapters.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // External
  await Hive.initFlutter();
  final dio = Dio();
  final localStorageService = HiveServiceImpl();
  dio.interceptors.add(
    AuthInterceptor(localStorageService),
  ); // Tambahkan interceptor
  sl.registerLazySingleton(() => dio);
  sl.registerLazySingleton<LocalStorageService>(() => localStorageService);

  // BLoC
  sl.registerFactory(() => AuthBloc(loginUsecase: sl()));

  // Use cases
  sl.registerLazySingleton(() => LoginUsecase(sl()));

  // Repositories
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(sl(), sl()),
  );

  // Data sources
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSource(sl()),
  );

  // External
  sl.registerLazySingleton(() => dio);
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(create: (context) => GetIt.instance<AuthBloc>()),
        // Anda bisa menambahkan BlocProvider lain di sini
      ],
      child: MaterialApp(
        title: 'Product CRUD App',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: const LoginPage(),
      ),
    );
  }
}
