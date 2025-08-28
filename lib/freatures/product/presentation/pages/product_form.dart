import 'dart:io';

import 'package:crud_product/freatures/product/domain/entities/product_entity.dart';
import 'package:crud_product/freatures/product/presentation/cubit/product_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:image_picker/image_picker.dart';
import 'package:logger/logger.dart';

class ProductFormPage extends StatefulWidget {
  final ProductEntity? product;
  const ProductFormPage({super.key, this.product});

  @override
  State<ProductFormPage> createState() => _ProductFormPageState();
}

class _ProductFormPageState extends State<ProductFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _priceController = TextEditingController();
  File? _selectedImage;

  @override
  void initState() {
    super.initState();
    if (widget.product != null) {
      _nameController.text = widget.product!.name;
      _descriptionController.text = widget.product!.description;
      _priceController.text = widget.product!.price.toString();
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  void _saveProduct(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      if (widget.product == null) {
        context.read<ProductCubit>().createProduct(
          name: _nameController.text,
          description: _descriptionController.text,
          price: double.parse(_priceController.text),
          image: _selectedImage?.path,
        );
      }
    }
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  void _showSnackbar(BuildContext context, String? message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message ?? 'Operasi berhasil'),
        backgroundColor: color,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isUpdating = widget.product != null;

    return Scaffold(
      appBar: AppBar(title: Text(isUpdating ? 'Ubah Produk' : 'Tambah Produk')),
      body: BlocListener<ProductCubit, ProductState>(
        listener: (context, state) {
          Logger().d("Listener");
          if (state is ProductListLoaded) {
            Logger().d("ProductListLoaded");
            final color = state.session == 'success'
                ? Colors.green
                : Colors.red;
            _showSnackbar(context, state.message, color);
            Navigator.pop(context);
          } else if (state is ProductsFailure) {
            Logger().d("ProductsFailure");
            _showSnackbar(context, state.message, Colors.red);
          }
        },
        child: Builder(
          builder: (context) {
            final state = context.watch<ProductCubit>().state;
            if (state is ProductsLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            return Form(
              key: _formKey,
              child: ListView(
                padding: const EdgeInsets.all(16.0),
                children: [
                  const SizedBox(height: 16),
                  // PENYESUAIAN: Bagian untuk pratinjau dan pilih gambar
                  _selectedImage != null
                      ? Image.file(
                          _selectedImage!,
                          height: 200,
                          fit: BoxFit.cover,
                        )
                      : const Text('Belum ada gambar yang dipilih.'),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _nameController,
                    decoration: const InputDecoration(labelText: 'Nama Produk'),
                    validator: (value) =>
                        value!.isEmpty ? 'Nama tidak boleh kosong' : null,
                  ),
                  TextFormField(
                    controller: _priceController,
                    decoration: const InputDecoration(labelText: 'Harga'),
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    validator: (value) =>
                        value!.isEmpty ||
                            double.tryParse(value.replaceAll(',', '.')) == null
                        ? 'Masukkan harga yang valid'
                        : null,
                  ),
                  const SizedBox(height: 40),
                  ElevatedButton.icon(
                    onPressed: _pickImage,
                    icon: const Icon(Icons.image),
                    label: const Text('Pilih Gambar'),
                  ),
                  const SizedBox(height: 40),

                  TextFormField(
                    minLines: 3,
                    maxLines: 5,
                    controller: _descriptionController,
                    decoration: const InputDecoration(
                      labelText: 'Deskripsi (Opsional)',
                    ),
                  ),
                  const SizedBox(height: 40),
                  ElevatedButton(
                    onPressed: () => _saveProduct(context),
                    child: Text(isUpdating ? 'Ubah' : 'Simpan'),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
