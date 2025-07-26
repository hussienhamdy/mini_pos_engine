part of 'cart_bloc.dart';

abstract class CartEvent extends Equatable {
  const CartEvent();

  @override
  List<Object> get props => [];
}

class AddItem extends CartEvent {
  final Item item;

  const AddItem(this.item);

  @override
  List<Object> get props => [item];
}

class RemoveItem extends CartEvent {
  final CartLine cartLine;

  const RemoveItem(this.cartLine);

  @override
  List<Object> get props => [cartLine];
}

class ChangeQty extends CartEvent {
  final CartLine cartLine;
  final int quantity;

  const ChangeQty(this.cartLine, this.quantity);

  @override
  List<Object> get props => [cartLine, quantity];
}

class ChangeDiscount extends CartEvent {
  final CartLine cartLine;
  final double discount;

  const ChangeDiscount(this.cartLine, this.discount);

  @override
  List<Object> get props => [cartLine, discount];
}

class ClearCart extends CartEvent {}

class UndoLastNActions extends CartEvent {
  final int actionsCount;

  const UndoLastNActions(this.actionsCount);

  @override
  List<Object> get props => [actionsCount];
}

class RedoLastNActions extends CartEvent {
  final int actionsCount;

  const RedoLastNActions(this.actionsCount);
  @override
  List<Object> get props => [actionsCount];
}
