import 'package:mini_pos_engine/src/cart/domain/entities/cart_data.dart';
import 'package:mini_pos_engine/src/cart/domain/entities/cart_line.dart';
import 'package:mini_pos_engine/src/cart/domain/entities/totals.dart';
import 'package:mini_pos_engine/src/core/utils.dart';

class RemoveItemUseCase {
  CartData call(CartData cartData, CartLine removedLine) {
    List<CartLine> currentCartLines = List.from(cartData.cartLines);
    Totals totals = cartData.totals;
    final itemCartLineIndex = currentCartLines.indexWhere(
      (line) => line.item.id == removedLine.item.id,
    );
    if (itemCartLineIndex != -1) {
      currentCartLines = List<CartLine>.from(currentCartLines)
        ..removeAt(itemCartLineIndex);
    }
    totals = calculateTotals(currentCartLines);
    return cartData.copyWith(cartLines: currentCartLines, totals: totals);
  }
}
