import 'package:mini_pos_engine/src/cart/domain/entities/cart_data.dart';
import 'package:mini_pos_engine/src/cart/domain/entities/cart_line.dart';
import 'package:mini_pos_engine/src/cart/domain/entities/receipt.dart';
import 'package:mini_pos_engine/src/cart/domain/entities/totals.dart';
import 'package:mini_pos_engine/src/core/constants.dart';

Totals calculateTotals(List<CartLine> cartLines) {
  double subtotal = 0;
  for (var line in cartLines) {
    subtotal += line.item.price * line.quantity * (1 - line.discount);
  }
  final vat = subtotal * vatPercentage;
  final grandTotal = subtotal + vat;
  return Totals(subtotal: subtotal, vat: vat, grandTotal: grandTotal);
}

Receipt buildReceipt(CartData data, DateTime date) {
  final String receiptId = 'REC-${date.millisecondsSinceEpoch}';
  return Receipt(receiptHeader: receiptId, cartData: data, checkoutDate: date);
}
