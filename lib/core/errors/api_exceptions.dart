
class ApiException implements Exception {
  final String message;
  final int? statusCode;

  ApiException(this.message, {this.statusCode});

  @override
  String toString() => 'ApiException: $message (code: $statusCode)';
}

class NetworkException extends ApiException {
  NetworkException([String message = "No Internet Connection"])
      : super(message);
}

class ServerException extends ApiException {
  ServerException([String message = "Server Error Occurred"])
      : super(message);
}

class UnauthorizedException extends ApiException {
  UnauthorizedException([String message = "Unauthorized Access"])
      : super(message, statusCode: 401);
}

class BadRequestException extends ApiException {
  BadRequestException([String message = "Bad Request"])
      : super(message, statusCode: 400);
}

class UnknownException extends ApiException {
  UnknownException([String message = "Unknown Error"])
      : super(message);
}
class NotFoundException extends ApiException {
  NotFoundException([String message = "Resource Not Found"])
      : super(message, statusCode: 404);
}