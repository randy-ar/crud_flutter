import 'package:crud_product/core/error/failures.dart';
import 'package:crud_product/core/usecase/usecase.dart';
import 'package:crud_product/freatures/product/data/models/product_list_response_model.dart';
import 'package:crud_product/freatures/product/data/models/product_single_response_model.dart';
import 'package:crud_product/freatures/product/domain/entities/product_entity.dart';
import 'package:crud_product/freatures/product/domain/usecase/create_product_usecase.dart';
import 'package:crud_product/freatures/product/domain/usecase/delete_product_usecase.dart';
import 'package:crud_product/freatures/product/domain/usecase/get_products_usecase.dart';
import 'package:crud_product/freatures/product/domain/usecase/update_product_usecase.dart';
import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';

class ProductCubit extends Cubit<ProductState> {
  final GetProductsUsecase getProductsUsecase;
  final CreateProductUsecase createProductUsecase;
  final UpdateProductUsecase updateProductUsecase;
  final DeleteProductUsecase deleteProductUsecase;

  ProductCubit(
    this.getProductsUsecase,
    this.createProductUsecase,
    this.updateProductUsecase,
    this.deleteProductUsecase,
  ) : super(ProductInitial());

  Future<void> getProducts() async {
    Logger().d("Loading get products");
    emit(ProductsLoading());
    Logger().d("Get products");
    final result = await getProductsUsecase.call(NoParams());
    Logger().d("Fold result");
    result.fold(
      (failure) => emit(ProductsFailure(message: failure.message)),
      (responseModel) => emit(
        ProductListLoaded(data: responseModel.data),
      ), // Mengambil 'data' di sini
    );
    Logger().d("Takes long?");
  }

  Future<void> createProduct({
    required String name,
    required double price,
    String? description,
    String? image,
  }) async {
    Logger().d("Create product");
    Logger().d("Product list loaded");
    final params = CreateParams(
      name: name,
      price: price,
      description: description,
      image: image,
    );
    Logger().d("Create params");
    final result = await createProductUsecase.call(params);
    Logger().d("Fold result");
    result.fold(
      (failure) => {
        Logger().d("Fold failure"),
        if (failure is InputFailure)
          {
            emit(
              ProductInputError(
                data: failure.data,
                statusCode: failure.statusCode,
                statusMessage: failure.statusMessage,
                requestOptions: failure.requestOptions,
              ),
            ),
          }
        else
          {emit(ProductsFailure(message: failure.message))},
      },
      (result) {
        Logger().d("Fold success");
        // PENYESUAIAN PENTING DI SINI
        List<ProductEntity> updatedList = [];
        if (state is ProductListLoaded) {
          // Jika state saat ini adalah ProductsLoaded, tambahkan data baru ke list yang sudah ada
          updatedList = [result.data!, ...(state as ProductListLoaded).data];
        } else {
          // Jika tidak, buat list baru hanya dengan data yang baru ditambahkan
          updatedList = [result.data!];
        }

        // Emit state dengan list yang sudah diperbarui
        emit(
          ProductListLoaded(
            data: updatedList,
            session: result.session,
            message: result.message,
          ),
        );
      },
    );
  }

  Future<void> updateProduct({
    required int id,
    required String name,
    required double price,
    String? description,
    String? image,
  }) async {
    Logger().d("Update product");
    final param = UpdateParam(
      id: id,
      name: name,
      price: price,
      description: description,
      image: image,
    );
    final result = await updateProductUsecase.call(param);
  }

  Future<void> deleteProduct({required int id}) async {
    Logger().d("Delete product");
    Logger().d("Delete ID : ");
    Logger().d(id);
    final param = DeleteParam(id: id);
    final result = await deleteProductUsecase.call(param);
    result.fold((failure) => emit(ProductsFailure(message: failure.message)), (
      result,
    ) {
      final currentProducts = (state as ProductListLoaded).data;
      Logger().d("Current products: $currentProducts");
      Logger().d("Product to delete: $id");
      final updatedProducts = currentProducts.where((p) => p.id != id).toList();
      Logger().d("Updated products: $updatedProducts");
      emit(
        ProductListLoaded(
          session: result.session,
          message: result.message,
          data: updatedProducts,
        ),
      );
    });
  }
}

abstract class ProductState {
  List<dynamic> get props => [];
}

class ProductInitial extends ProductState {}

class ProductsLoading extends ProductState {}

class ProductListLoaded extends ProductState {
  final List<ProductEntity> data;
  final String? session;
  final String? message;
  bool loading = false;

  ProductListLoaded({
    required this.data,
    this.loading = false,
    this.session,
    this.message,
  });

  @override
  List<dynamic> get props => [data, session, message, loading];
}

class ProductSingleLoaded extends ProductState {
  final ProductSingleResponseModel productSingleResponse;

  ProductSingleLoaded({required this.productSingleResponse});

  @override
  List<Object> get props => [productSingleResponse];
}

class ProductsFailure extends ProductState {
  final String message;

  ProductsFailure({required this.message});

  @override
  List<Object> get props => [message];
}

class ProductInputError extends ProductState {
  final InputErrorWrapper data;
  final int? statusCode;
  final String? statusMessage;
  final RequestOptions requestOptions;

  ProductInputError({
    required this.data,
    required this.statusCode,
    required this.statusMessage,
    required this.requestOptions,
  });

  @override
  List<Object> get props => [];
}
