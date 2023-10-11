class ServerException implements Exception {
  final String message;

  const ServerException(this.message);

  @override
  String toString() {
    return message;
  }
}

class SubmitException implements Exception {
  final String title, message;

  const SubmitException({required this.title, required this.message});

  @override
  String toString() {
    return message;
  }
}
