class ServerException implements Exception {}

class OfflineException implements Exception {}

class PrimaryServerException implements Exception {
  final String error, message;
  final int code;

  PrimaryServerException({
    required this.error,
    required this.message,
    required this.code,
  });
}
