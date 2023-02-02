part of http;

class StatusException implements Exception {
  StatusException({required this.status, required this.message});

  final int status;
  final String message;

  @override
  String toString() {
    return 'http request exception [$status]: $message';
  }
}

class AuthorizationException extends StatusException {
  AuthorizationException({required int status, required String message})
      : super(status: status, message: message);
}

class ValidationException extends StatusException {
  ValidationException({required int status, required String message})
      : super(status: status, message: message);
}

class NetworkException extends StatusException {
  NetworkException({required int status, required String message})
      : super(status: status, message: message);
}

class CancelRequestException extends StatusException {
  CancelRequestException({required int status, required String message})
      : super(status: status, message: message);
}
