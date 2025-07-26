import 'package:equatable/equatable.dart';
import 'package:mini_pos_engine/src/cart/domain/entities/cart_data.dart';

class Receipt extends Equatable {
  final CartData cartData;
  final DateTime checkoutDate;
  final String receiptHeader;

  const Receipt({
    required this.cartData,
    required this.checkoutDate,
    required this.receiptHeader,
  });

  @override
  List<Object> get props => [cartData, checkoutDate, receiptHeader];
}
