import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mini_pos_engine/src/cart/domain/entities/cart_data.dart';
import 'package:mini_pos_engine/src/cart/domain/entities/cart_line.dart';
import 'package:mini_pos_engine/src/cart/domain/entities/totals.dart';
import 'package:mini_pos_engine/src/cart/domain/usecases/add_item_usecase.dart';
import 'package:mini_pos_engine/src/cart/domain/usecases/change_discount_usecase.dart';
import 'package:mini_pos_engine/src/cart/domain/usecases/change_quantity_usecase.dart';
import 'package:mini_pos_engine/src/cart/domain/usecases/checkout_usecase.dart';
import 'package:mini_pos_engine/src/cart/domain/usecases/remove_item_usecase.dart';
import 'package:mini_pos_engine/src/cart/presentation/blocs/cart_bloc.dart';
import 'package:mini_pos_engine/src/catalog/domain/entities/item.dart';
import 'package:mini_pos_engine/src/core/constants.dart';
import 'package:mocktail/mocktail.dart';

class MockAddItemUseCase extends Mock implements AddItemUseCase {}

class MockRemoveItemUseCase extends Mock implements RemoveItemUseCase {}

class MockChangeQuantityUseCase extends Mock implements ChangeQuantityUseCase {}

class MockChangeDiscountUseCase extends Mock implements ChangeDiscountUseCase {}

class MockCheckoutUseCase extends Mock implements CheckoutUseCase {}

void main() {
  late CartBloc cartBloc;
  late MockAddItemUseCase mockAddItemUseCase;
  late MockRemoveItemUseCase mockRemoveItemUseCase;
  late MockChangeQuantityUseCase mockChangeQuantityUseCase;
  late MockChangeDiscountUseCase mockChangeDiscountUseCase;
  late MockCheckoutUseCase mockCheckoutUseCase;

  setUp(() {
    mockAddItemUseCase = MockAddItemUseCase();
    mockRemoveItemUseCase = MockRemoveItemUseCase();
    mockChangeQuantityUseCase = MockChangeQuantityUseCase();
    mockChangeDiscountUseCase = MockChangeDiscountUseCase();
    mockCheckoutUseCase = MockCheckoutUseCase();
    cartBloc = CartBloc(
      mockAddItemUseCase,
      mockRemoveItemUseCase,
      mockChangeDiscountUseCase,
      mockChangeQuantityUseCase,
      mockCheckoutUseCase,
    );
  });

  group('Cart Bloc', () {
    final items = [
      const Item(id: '1', name: 'Test Item 1', price: 10.0),
      const Item(id: '1', name: 'Test Item 1', price: 10.0),
      const Item(id: '2', name: 'Test Item 2', price: 20.0),
      const Item(id: '3', name: 'Test Item 3', price: 50.0),
    ];

    blocTest<CartBloc, CartState>(
      'emits [CartLoaded] when an Item is added to an empty cart',
      seed: () {
        return CartInitial();
      },
      build: () {
        when(
          () => mockAddItemUseCase.call(
            CartData(cartLines: [], totals: Totals.empty()),
            items[0],
          ),
        ).thenAnswer((_) {
          double subTotal = items[0].price * 1 * (1 - 0.0);
          double vat = subTotal * vatPercentage;
          double grandTotal = subTotal + vat;
          return CartData(
            cartLines: [CartLine(item: items[0])],
            totals: Totals(
              subtotal: subTotal,
              vat: vat,
              grandTotal: grandTotal,
            ),
          );
        });
        return cartBloc;
      },
      act: (bloc) => bloc.add(AddItem(items[0])),
      expect: () {
        double subTotal = items[0].price * 1 * (1 - 0.0);
        double vat = subTotal * vatPercentage;
        double grandTotal = subTotal + vat;
        return [
          CartLoaded(
            cartData: CartData(
              cartLines: [CartLine(item: items[0])],
              totals: Totals(
                subtotal: subTotal,
                vat: vat,
                grandTotal: grandTotal,
              ),
            ),
          ),
        ];
      },
      verify: (_) {
        verify(
          () => mockAddItemUseCase.call(
            CartData(cartLines: [], totals: Totals.empty()),
            items[0],
          ),
        ).called(1);
      },
    );

    blocTest<CartBloc, CartState>(
      'emits [CartLoaded] when an Item is added to to a cart with existing items',
      seed: () {
        double subTotal = items[0].price * 1 * (1 - 0.0);
        double vat = subTotal * vatPercentage;
        double grandTotal = subTotal + vat;
        return CartLoaded(
          cartData: CartData(
            cartLines: [CartLine(item: items[0])],
            totals: Totals(
              subtotal: subTotal,
              vat: vat,
              grandTotal: grandTotal,
            ),
          ),
        );
      },
      build: () {
        double subTotal = items[0].price * 1 * (1 - 0.0);
        double vat = subTotal * vatPercentage;
        double grandTotal = subTotal + vat;
        when(
          () => mockAddItemUseCase.call(
            CartData(
              cartLines: [CartLine(item: items[0])],
              totals: Totals(
                subtotal: subTotal,
                vat: vat,
                grandTotal: grandTotal,
              ),
            ),
            items[2],
          ),
        ).thenAnswer((_) {
          double subTotal =
              (items[0].price * 1 * (1 - 0.0)) +
              (items[2].price * 1 * (1 - 0.0));
          double vat = subTotal * vatPercentage;
          double grandTotal = subTotal + vat;
          return CartData(
            cartLines: [
              CartLine(item: items[0], quantity: 1),
              CartLine(item: items[2], quantity: 1),
            ],
            totals: Totals(
              subtotal: subTotal,
              vat: vat,
              grandTotal: grandTotal,
            ),
          );
        });
        return cartBloc;
      },
      act: (bloc) => bloc.add(AddItem(items[2])),
      expect: () {
        double subTotal =
            (items[0].price * 1 * (1 - 0.0)) + (items[2].price * 1 * (1 - 0.0));
        double vat = subTotal * vatPercentage;
        double grandTotal = subTotal + vat;
        return [
          CartLoaded(
            cartData: CartData(
              cartLines: [
                CartLine(item: items[0], quantity: 1),
                CartLine(item: items[2], quantity: 1),
              ],
              totals: Totals(
                subtotal: subTotal,
                vat: vat,
                grandTotal: grandTotal,
              ),
            ),
          ),
        ];
      },
      verify: (_) {
        double subTotal = items[0].price * 1 * (1 - 0.0);
        double vat = subTotal * vatPercentage;
        double grandTotal = subTotal + vat;
        verify(
          () => mockAddItemUseCase.call(
            CartData(
              cartLines: [CartLine(item: items[0])],
              totals: Totals(
                subtotal: subTotal,
                vat: vat,
                grandTotal: grandTotal,
              ),
            ),
            items[2],
          ),
        ).called(1);
      },
    );
  });
}
