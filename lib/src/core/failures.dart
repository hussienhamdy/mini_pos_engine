import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {}

class FailureWithMessage extends Failure {
  final String message;
  FailureWithMessage({required this.message});
  @override
  List<Object?> get props => [];
}
