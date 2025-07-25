part of 'cart_bloc.dart';

abstract class CartState extends Equatable {
  const CartState();

  @override
  List<Object> get props => [];
}

class CartInitial extends CartState {}

class CartLoaded extends CartState {
  final CartData cartData;

  const CartLoaded({required this.cartData});

  @override
  List<Object> get props => [cartData];
}
