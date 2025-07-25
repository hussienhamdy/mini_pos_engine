import 'package:mini_pos_engine/src/cart/domain/entities/cart_data.dart';
import 'package:mini_pos_engine/src/cart/domain/entities/receipt.dart';

class CheckoutUseCase {
  Receipt call(CartData cartData) {
    Receipt receipt = buildReceipt(cartData, DateTime.now());
    return receipt;
  }
}
