import 'package:equatable/equatable.dart';
import 'package:mini_pos_engine/src/cart/domain/entities/cart_line.dart';
import 'package:mini_pos_engine/src/cart/domain/entities/totals.dart';

class CartData extends Equatable {
  final List<CartLine> cartLines;
  final Totals totals;

  const CartData({required this.cartLines, required this.totals});

  @override
  List<Object> get props => [cartLines, totals];

  @override
  String toString() => 'CartData(cartLines: $cartLines, totals: $totals)';

  CartData copyWith({List<CartLine>? cartLines, Totals? totals}) {
    return CartData(
      cartLines: cartLines ?? this.cartLines,
      totals: totals ?? this.totals,
    );
  }

  factory CartData.fromJson(Map<String, dynamic> json) {
    return CartData(
      cartLines: (json['cartLines'] as List<dynamic>)
          .map((e) => CartLine.fromJson(e as Map<String, dynamic>))
          .toList(),
      totals: Totals.fromJson(json['totals'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'cartLines': cartLines.map((e) => e.toJson()).toList(),
      'totals': totals.toJson(),
    };
  }
}
