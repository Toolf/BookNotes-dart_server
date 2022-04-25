class ApiException implements Exception {
  final String message;
  final dynamic inner;

  ApiException(this.message, this.inner);

  @override
  String toString() {
    return "ApiException: $message";
  }
}
