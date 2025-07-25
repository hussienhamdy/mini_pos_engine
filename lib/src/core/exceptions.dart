class ExceptionWithMessage implements Exception {
  final String message;

  ExceptionWithMessage({required this.message});

  @override
  String toString() {
    return 'ExceptionWithMessage: $message';
  }
}
