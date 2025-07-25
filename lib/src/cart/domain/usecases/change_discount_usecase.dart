import 'package:mini_pos_engine/src/cart/domain/entities/cart_data.dart';
import 'package:mini_pos_engine/src/cart/domain/entities/cart_line.dart';
import 'package:mini_pos_engine/src/cart/domain/entities/totals.dart';
import 'package:mini_pos_engine/src/core/utils.dart';

class ChangeDiscountUseCase {
  CartData call(CartData cartData, CartLine cartLine, double discount) {
    List<CartLine> currentCartLines = List.from(cartData.cartLines);
    Totals totals = cartData.totals;
    final itemCartLineIndex = currentCartLines.indexWhere(
      (line) => line.item.id == cartLine.item.id,
    );
    currentCartLines[itemCartLineIndex] = currentCartLines[itemCartLineIndex]
        .copyWith(discount: discount);
    totals = calculateTotals(currentCartLines);
    return cartData.copyWith(cartLines: currentCartLines, totals: totals);
  }
}
