import 'package:equatable/equatable.dart';
import 'package:mini_pos_engine/src/catalog/domain/entities/item.dart';

class CartLine extends Equatable {
  const CartLine({required this.item, this.quantity = 1, this.discount = 0.0});

  final Item item;
  final int quantity;
  final double discount;

  CartLine copyWith({int? quantity, double? discount}) {
    return CartLine(
      item: item,
      quantity: quantity ?? this.quantity,
      discount: discount ?? this.discount,
    );
  }

  @override
  List<Object?> get props => [item, quantity, discount];

  @override
  String toString() =>
      'CartLine(item: $item, quantity: $quantity, discount: $discount)';

  factory CartLine.fromJson(Map<String, dynamic> json) {
    return CartLine(
      item: Item.fromJson(json['item'] as Map<String, dynamic>),
      quantity: json['quantity'] as int,
      discount: json['discount'] as double,
    );
  }

  Map<String, dynamic> toJson() {
    return {'item': item.toJson(), 'quantity': quantity, 'discount': discount};
  }
}
