import 'package:equatable/equatable.dart';

class ProductEntity extends Equatable {
  final int? id;
  final String name;
  final double price;
  final String? description;
  final String? image;

  const ProductEntity({
    this.id,
    required this.name,
    required this.price,
    this.description,
    this.image,
  });

  @override
  List<Object?> get props => [id, name, description, price, image];
}
