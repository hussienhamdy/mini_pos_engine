import 'package:equatable/equatable.dart';

class Item extends Equatable {
  const Item({required this.id, required this.name, required this.price});

  final String id;
  final String name;
  final double price;

  @override
  List<Object?> get props => [id, name, price];

  @override
  String toString() => 'Item(id: $id, name: $name, price: $price)';
}
