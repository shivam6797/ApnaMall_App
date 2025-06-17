import 'package:apnamall_ecommerce_app/core/errors/api_exceptions.dart';
import 'package:apnamall_ecommerce_app/core/network/api_endpoint.dart';
import 'package:dio/dio.dart';

class ApiClient {
  final Dio _dio;

  ApiClient()
      : _dio = Dio(BaseOptions(
          baseUrl: ApiEndpoint.baseUrl,
          connectTimeout: const Duration(seconds: 15),
          receiveTimeout: const Duration(seconds: 15),
          sendTimeout: const Duration(seconds: 15),
          contentType: 'application/json',
        ));

  Future<Response> post(
    String url, {
    Map<String, dynamic>? body,
    String? bearerToken,
  }) async {
    try {
      final response = await _dio.post(
        url,
        data: body,
        options: _buildOptions(token: bearerToken),
      );
      return response;
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  Future<Response> get(
    String url, {
    Map<String, dynamic>? query,
    String? bearerToken,
  }) async {
    try {
      final response = await _dio.get(
        url,
        queryParameters: query,
        options: _buildOptions(token: bearerToken),
      );
      return response;
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  Options _buildOptions({String? token}) {
    return Options(
      headers: token == null
          ? null
          : {
              'Authorization': 'Bearer $token',
            },
    );
  }

  ApiException _handleDioError(DioException e) {
    if (e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.receiveTimeout ||
        e.type == DioExceptionType.sendTimeout) {
      return NetworkException();
    } else if (e.type == DioExceptionType.badResponse) {
      final statusCode = e.response?.statusCode ?? 500;
      final message = e.response?.data['message'] ?? 'Something went wrong';

      if (statusCode == 400) return BadRequestException(message);
      if (statusCode == 401) return UnauthorizedException(message);
      if (statusCode >= 500) return ServerException(message);

      return ApiException(message, statusCode: statusCode);
    } else if (e.type == DioExceptionType.unknown) {
      return NetworkException();
    } else {
      return UnknownException();
    }
  }
}
