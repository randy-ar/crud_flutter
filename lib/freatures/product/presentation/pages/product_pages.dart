import 'package:cached_network_image/cached_network_image.dart';
import 'package:crud_product/freatures/auth/presentation/bloc/auth_bloc.dart';
import 'package:crud_product/freatures/auth/presentation/pages/login_page.dart';
import 'package:crud_product/freatures/product/domain/entities/product_entity.dart';
import 'package:crud_product/freatures/product/presentation/cubit/product_cubit.dart';
import 'package:crud_product/freatures/product/presentation/pages/product_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

class ProductsPage extends StatefulWidget {
  const ProductsPage({super.key});

  @override
  State<ProductsPage> createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage> {
  @override
  void dispose() {
    super.dispose();
    context.read<ProductCubit>().close();
  }

  @override
  void initState() {
    super.initState();
    context.read<ProductCubit>().getProducts();
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Logout'),
          content: const Text('Apakah Anda yakin ingin logout?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Batal'),
            ),
            TextButton(
              onPressed: () {
                context.read<AuthBloc>().add(LogoutButtonPressed());
                // GetIt.I<AuthBloc>().add(LogoutButtonPressed());
              },
              child: const Text('Ya'),
            ),
          ],
        );
      },
    );
  }

  void _showProductBottomSheet(ProductEntity product) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                product.name,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text('Rp. ${product.price.toStringAsFixed(0)}'),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton.icon(
                    icon: const Icon(Icons.edit),
                    label: const Text('Edit'),
                    onPressed: () async {
                      Navigator.of(context).pop();
                      await Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) =>
                              ProductFormPage(product: product),
                        ),
                      );
                      if (context.mounted) {
                        context.read<ProductCubit>().getProducts();
                      }
                    },
                  ),
                  if (product.id != null)
                    ElevatedButton.icon(
                      icon: Icon(Icons.delete),
                      onPressed: () {
                        Navigator.pop(context);
                        _showDeleteConfirmationDialog(context, product);
                      },
                      label: Text("Hapus"),
                    ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  void _showDeleteConfirmationDialog(
    BuildContext context,
    ProductEntity product,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Hapus Produk"),
        content: Text("Apakah Anda yakin ingin menghapus produk ini?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text("Batal"),
          ),
          if (product.id != null)
            ElevatedButton(
              child: Text("Hapus"),
              onPressed: () {
                Navigator.pop(context);
                context.read<ProductCubit>().deleteProduct(id: product.id!);
              },
            ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthLogoutSuccess) {
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => const LoginPage()),
            (route) => false,
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Daftar Produk'),
          actions: [
            IconButton(
              icon: const Icon(Icons.logout),
              onPressed: () {
                _showLogoutDialog(context);
              },
            ),
          ],
        ),
        body: BlocBuilder<ProductCubit, ProductState>(
          builder: (context, state) {
            if (state is ProductsLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is ProductListLoaded) {
              return GridView.builder(
                padding: const EdgeInsets.all(8.0),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 8.0,
                  mainAxisSpacing: 8.0,
                  childAspectRatio: 0.75,
                ),
                itemCount: state.data.length,
                itemBuilder: (context, index) {
                  final product = state.data[index];
                  return Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: InkWell(
                      onTap: () {
                        _showProductBottomSheet(product);
                      },
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Expanded(
                            child: ClipRRect(
                              borderRadius: const BorderRadius.vertical(
                                top: Radius.circular(10.0),
                              ),
                              child: CachedNetworkImage(
                                imageUrl: product.image!,
                                fit: BoxFit.cover,
                                placeholder: (context, url) => const Center(
                                  child: CircularProgressIndicator(),
                                ),
                                errorWidget: (context, url, error) =>
                                    const Icon(Icons.error),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  product.name,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Rp. ${product.price.toStringAsFixed(0)}',
                                  style: const TextStyle(
                                    color: Colors.grey,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            } else if (state is ProductsFailure) {
              return Center(
                child: Text('Gagal memuat produk: ${state.message}'),
              );
            }
            return const SizedBox.shrink();
          },
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            // Navigasi ke halaman tambah produk
            await Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => const ProductFormPage()),
            );
          },
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}
