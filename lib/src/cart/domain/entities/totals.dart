import 'package:equatable/equatable.dart';

class Totals extends Equatable {
  const Totals({this.subtotal = 0.0, this.grandTotal = 0.0, this.vat = 0.0});

  factory Totals.empty() {
    return const Totals(subtotal: 0.0, grandTotal: 0.0, vat: 0.0);
  }

  final double subtotal;
  final double grandTotal;
  final double vat;

  @override
  List<Object?> get props => [subtotal, grandTotal, vat];

  @override
  String toString() =>
      'Totals(subtotal: $subtotal, grandTotal: $grandTotal, vat: $vat)';
}
