import 'package:equatable/equatable.dart';
import 'package:mini_pos_engine/src/cart/domain/entities/cart_data.dart';

class Receipt extends Equatable {
  final CartData cartData;
  final DateTime checkoutDate;

  const Receipt({required this.cartData, required this.checkoutDate});

  @override
  List<Object> get props => [cartData, checkoutDate];
}

Receipt buildReceipt(CartData cartData, DateTime checkoutDate) {
  return Receipt(cartData: cartData, checkoutDate: checkoutDate);
}
