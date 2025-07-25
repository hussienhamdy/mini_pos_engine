import 'package:mini_pos_engine/src/cart/domain/entities/cart_data.dart';
import 'package:mini_pos_engine/src/cart/domain/entities/cart_line.dart';
import 'package:mini_pos_engine/src/cart/domain/entities/totals.dart';
import 'package:mini_pos_engine/src/catalog/domain/entities/item.dart';
import 'package:mini_pos_engine/src/core/utils.dart';

class AddItemUseCase {
  CartData call(CartData cartData, Item item) {
    List<CartLine> currentCartLines = List.from(cartData.cartLines);
    Totals totals = cartData.totals;
    final itemCartLineIndex = currentCartLines.indexWhere(
      (line) => line.item.id == item.id,
    );
    if (itemCartLineIndex != -1) {
      currentCartLines[itemCartLineIndex] = currentCartLines[itemCartLineIndex]
          .copyWith(quantity: currentCartLines[itemCartLineIndex].quantity + 1);
    } else {
      currentCartLines.add(CartLine(item: item, quantity: 1));
    }
    totals = calculateTotals(currentCartLines);
    return cartData.copyWith(cartLines: currentCartLines, totals: totals);
  }
}
