import 'dart:math';

import 'package:equatable/equatable.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:mini_pos_engine/src/cart/domain/entities/cart_data.dart';
import 'package:mini_pos_engine/src/cart/domain/entities/cart_line.dart';
import 'package:mini_pos_engine/src/cart/domain/entities/totals.dart';
import 'package:mini_pos_engine/src/cart/domain/usecases/add_item_usecase.dart';
import 'package:mini_pos_engine/src/cart/domain/usecases/change_discount_usecase.dart';
import 'package:mini_pos_engine/src/cart/domain/usecases/change_quantity_usecase.dart';
import 'package:mini_pos_engine/src/cart/domain/usecases/checkout_usecase.dart';
import 'package:mini_pos_engine/src/cart/domain/usecases/remove_item_usecase.dart';
import 'package:mini_pos_engine/src/catalog/domain/entities/item.dart';

part 'cart_event.dart';
part 'cart_state.dart';

class CartBloc extends HydratedBloc<CartEvent, CartState> {
  final AddItemUseCase addItemUseCase;
  final RemoveItemUseCase removeItemUseCase;
  final ChangeDiscountUseCase changeDiscountUseCase;
  final ChangeQuantityUseCase changeQuantityUseCase;
  final CheckoutUseCase checkoutUseCase;
  late List<CartState> _undoStack;
  late List<CartState> _redoStack;

  CartBloc(
    this.addItemUseCase,
    this.removeItemUseCase,
    this.changeDiscountUseCase,
    this.changeQuantityUseCase,
    this.checkoutUseCase,
  ) : super(CartInitial()) {
    on<AddItem>(_onAddItem);
    on<RemoveItem>(_onRemoveItem);
    on<ChangeQty>(_onChangeQty);
    on<ChangeDiscount>(_onChangeDiscount);
    on<ClearCart>(_onClearCart);
    on<Checkout>(_onCheckout);
    on<UndoLastNActions>(_undoNLastActions);
    on<RedoLastNActions>(_redoNLastActions);
    _undoStack = [];
    _redoStack = [];
  }

  @override
  Future<void> close() {
    _undoStack = [];
    _redoStack = [];
    return super.close();
  }

  void _onAddItem(AddItem event, Emitter<CartState> emit) {
    _undoStack.add(state);
    CartData newCartData;
    if (state is CartLoaded) {
      newCartData = addItemUseCase.call(
        (state as CartLoaded).cartData,
        event.item,
      );
    } else {
      // state is CartInitial => no cart lines yet
      newCartData = addItemUseCase.call(
        CartData(cartLines: [], totals: Totals.empty()),
        event.item,
      );
    }
    emit(CartLoaded(cartData: newCartData));
  }

  void _onRemoveItem(RemoveItem event, Emitter<CartState> emit) {
    _undoStack.add(state);
    if (state is CartLoaded) {
      final state = this.state as CartLoaded;
      CartData newCartData = removeItemUseCase.call(
        (state).cartData,
        event.cartLine,
      );
      emit(CartLoaded(cartData: newCartData));
    }
  }

  void _onChangeQty(ChangeQty event, Emitter<CartState> emit) {
    _undoStack.add(state);
    if (state is CartLoaded) {
      final state = this.state as CartLoaded;
      CartData newCartData = changeQuantityUseCase.call(
        (state).cartData,
        event.cartLine,
        event.quantity,
      );
      emit(CartLoaded(cartData: newCartData));
    }
  }

  void _onChangeDiscount(ChangeDiscount event, Emitter<CartState> emit) {
    _undoStack.add(state);
    if (state is CartLoaded) {
      final state = this.state as CartLoaded;
      CartData newCartData = changeDiscountUseCase.call(
        (state).cartData,
        event.cartLine,
        event.discount,
      );
      emit(CartLoaded(cartData: newCartData));
    }
  }

  void _onClearCart(ClearCart event, Emitter<CartState> emit) {
    _undoStack.add(state);
    emit(CartInitial());
  }

  void _onCheckout(Checkout event, Emitter<CartState> emit) {
    if (state is CartLoaded) {
      final state = this.state as CartLoaded;
      checkoutUseCase.call(state.cartData);
      emit(
        CartLoaded(
          cartData: CartData(cartLines: [], totals: Totals.empty()),
        ),
      );
    }
  }

  void _undoNLastActions(UndoLastNActions event, Emitter<CartState> emit) {
    int count = min(_undoStack.length, event.actionsCount);
    for (int i = 0; i < count; i++) {
      _redoStack.add(_undoStack.removeLast());
    }
    if (_undoStack.isEmpty) {
      emit(CartInitial());
    } else {
      emit(_undoStack.last);
    }
  }

  void _redoNLastActions(RedoLastNActions event, Emitter<CartState> emit) {
    CartState stateToBeApplied = state;
    int count = min(_redoStack.length, event.actionsCount);
    for (int i = 0; i < count; i++) {
      stateToBeApplied = _redoStack.removeLast();
      _undoStack.add(stateToBeApplied);
    }
    emit(stateToBeApplied);
  }

  @override
  CartState? fromJson(Map<String, dynamic> json) {
    try {
      return CartLoaded.fromJson(json);
    } catch (_) {
      return null;
    }
  }

  @override
  Map<String, dynamic>? toJson(CartState state) {
    if (state is CartLoaded) {
      return state.toJson();
    } else {
      return null;
    }
  }
}
