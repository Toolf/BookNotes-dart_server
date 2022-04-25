class DbException implements Exception {
  final String message;
  final dynamic inner;

  DbException(this.message, this.inner);

  @override
  String toString() {
    return "DbException: $message";
  }
}
