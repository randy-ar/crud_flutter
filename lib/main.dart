import 'package:crud_product/core/local_storage/hive_service_impl.dart';
import 'package:crud_product/core/local_storage/local_storage_service.dart';
import 'package:crud_product/core/network/auth_interceptor.dart';
import 'package:crud_product/freatures/auth/domain/usecases/logout_use_case.dart';
import 'package:crud_product/freatures/auth/presentation/pages/login_page.dart';
import 'package:crud_product/freatures/product/data/repositories/product_repository_impl.dart';
import 'package:crud_product/freatures/product/data/src/product_remote_data_source.dart';
import 'package:crud_product/freatures/product/domain/repositories/product_repository.dart';
import 'package:crud_product/freatures/product/domain/usecase/create_product_usecase.dart';
import 'package:crud_product/freatures/product/domain/usecase/delete_product_usecase.dart';
import 'package:crud_product/freatures/product/domain/usecase/get_products_usecase.dart';
import 'package:crud_product/freatures/product/domain/usecase/update_product_usecase.dart';
import 'package:crud_product/freatures/product/presentation/cubit/product_cubit.dart';
import 'package:crud_product/freatures/product/presentation/pages/product_pages.dart';
import 'package:flutter/material.dart';
import 'package:crud_product/freatures/auth/data/src/auth_remote_data_source.dart';
import 'package:crud_product/freatures/auth/data/repositories/auth_repository_impl.dart';
import 'package:crud_product/freatures/auth/domain/repositories/auth_repository.dart';
import 'package:crud_product/freatures/auth/domain/usecases/login_use_case.dart';
import 'package:crud_product/freatures/auth/presentation/cubit/auth_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:dio/dio.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:logger/logger.dart';

final sl = GetIt.instance;

Future<void> init() async {
  Logger().d("EXTERNAL");
  // External
  await Hive.initFlutter();
  final dio = Dio(
    BaseOptions(
      baseUrl: 'http://192.168.3.169:8000/api',
      followRedirects: false,
      validateStatus: (status) {
        return status! < 400;
      },
    ),
  );
  final localStorageService = HiveServiceImpl();
  dio.interceptors.add(AuthInterceptor(localStorageService));

  Logger().d("INTERCEPTOR");
  sl.registerLazySingleton(() => dio);
  sl.registerLazySingleton<LocalStorageService>(() => localStorageService);

  Logger().d("USE CASES");
  // Use cases
  sl.registerLazySingleton(() => LoginUsecase(sl()));
  sl.registerLazySingleton(() => LogoutUsecase(sl()));
  sl.registerLazySingleton(() => GetProductsUsecase(productRepository: sl()));
  sl.registerLazySingleton(() => CreateProductUsecase(productRepository: sl()));
  sl.registerLazySingleton(() => UpdateProductUsecase(productRepository: sl()));
  sl.registerLazySingleton(() => DeleteProductUsecase(productRepository: sl()));

  Logger().d("BLOC/CUBIT");
  // BLoC & Cubit
  sl.registerFactory(() => AuthCubit(sl(), sl()));
  sl.registerFactory(() => ProductCubit(sl(), sl(), sl(), sl()));

  Logger().d("REPOSITORIES");
  // Repositories
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(sl(), sl()),
  );
  sl.registerLazySingleton<ProductRepository>(
    () => ProductRepositoryImpl(remoteDataSource: sl()),
  );

  Logger().d("DATA SOURCES");
  // Data sources
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSource(sl()),
  );
  sl.registerLazySingleton<ProductRemoteDataSource>(
    // Perbaiki typo
    () => ProductRemoteDataSource(sl()),
  );

  Logger().d("FINISH INIT");
}

void main() async {
  Logger().d("START");
  WidgetsFlutterBinding.ensureInitialized();
  Logger().d("INITIALIZE");
  await init();
  Logger().d("RUN APP");
  runApp(const MyApp());
  Logger().d("END");
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthCubit>(
          create: (context) => GetIt.instance<AuthCubit>(),
        ),
        BlocProvider<ProductCubit>(
          // PENYESUAIAN CUBIT
          create: (context) => GetIt.instance<ProductCubit>(),
        ),
      ],
      child: MaterialApp(
        title: 'Product CRUD App',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: FutureBuilder<String?>(
          future: GetIt.instance<LocalStorageService>().getToken(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Scaffold(
                body: Center(child: CircularProgressIndicator()),
              );
            }
            if (snapshot.hasData && snapshot.data != null) {
              return const ProductsPage();
            }
            return const LoginPage();
          },
        ),
      ),
    );
  }
}
