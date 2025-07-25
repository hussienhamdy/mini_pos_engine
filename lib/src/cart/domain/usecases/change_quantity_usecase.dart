import 'package:mini_pos_engine/src/cart/domain/entities/cart_data.dart';
import 'package:mini_pos_engine/src/cart/domain/entities/cart_line.dart';
import 'package:mini_pos_engine/src/cart/domain/entities/totals.dart';
import 'package:mini_pos_engine/src/core/utils.dart';

class ChangeQuantityUseCase {
  CartData call(CartData cartData, CartLine cartLine, int quantity) {
    List<CartLine> currentCartLines = List.from(cartData.cartLines);
    Totals totals = cartData.totals;
    final itemCartLineIndex = currentCartLines.indexWhere(
      (line) => line.item.id == cartLine.item.id,
    );
    if (quantity > 0) {
      currentCartLines[itemCartLineIndex] = currentCartLines[itemCartLineIndex]
          .copyWith(quantity: quantity);
    } else {
      currentCartLines.removeAt(itemCartLineIndex);
    }
    totals = calculateTotals(currentCartLines);
    return cartData.copyWith(cartLines: currentCartLines, totals: totals);
  }
}
