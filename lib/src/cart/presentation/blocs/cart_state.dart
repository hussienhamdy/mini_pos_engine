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

  factory CartLoaded.fromJson(Map<String, dynamic> json) {
    return CartLoaded(
      cartData: CartData.fromJson(json['cartData'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() {
    return {'cartData': cartData.toJson()};
  }
}
