import 'package:equatable/equatable.dart';

class ProductEntity extends Equatable {
  final int? id;
  final String name;
  final String description;
  final double price;
  final String? image;

  const ProductEntity({
    this.id,
    required this.name,
    required this.description,
    required this.price,
    this.image,
  });

  @override
  List<Object?> get props => [id, name, description, price, image];
}
