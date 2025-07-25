import 'package:mini_pos_engine/src/core/failures.dart';

class Either<T> {
  T? value;
  Failure? failure;
  Either({this.value, this.failure});
  getValue() {
    if (failure != null) {
      return failure;
    } else {
      return value;
    }
  }

  Either<T> copyWith({T? value, Failure? failure}) {
    return Either<T>(
      value: value ?? this.value,
      failure: failure ?? this.failure,
    );
  }
}
