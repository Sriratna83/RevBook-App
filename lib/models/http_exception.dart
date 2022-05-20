enum HttpExceptionType {
  unknown,
  responseNull,
}

class HttpException implements Exception {
  final String message;
  final HttpExceptionType typeException;

  HttpException({
    required this.message,
    this.typeException = HttpExceptionType.unknown,
  });

  @override
  String toString() {
    return message;
  }
}
