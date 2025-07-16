import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../errors/api_exceptions.dart';
import 'api_endpoint.dart';

class ApiClient {
  final Dio _dio;
  final FlutterSecureStorage _secure = const FlutterSecureStorage();

  ApiClient()
    : _dio = Dio(
        BaseOptions(
          baseUrl: ApiEndpoint.baseUrl,
          connectTimeout: const Duration(seconds: 15),
          receiveTimeout: const Duration(seconds: 30),
          sendTimeout: const Duration(seconds: 15),
          contentType: 'application/json',
        ),
      ) {
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final skipAuth = options.headers['skipAuth'] == true;

          final token = await _secure.read(key: 'token');
          print('🟡 Request URL: ${options.uri}');
          print('🔐 Token from SecureStorage: $token');

          if (!skipAuth && token != null && token.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $token';
            print("✅ Injected Authorization Header");
          } else if (skipAuth) {
            print("⛔ Skipping token injection due to skipAuth flag");
          } else {
            print("❌ No token found to inject.");
          }

          // Remove skipAuth before actual request
          options.headers.remove('skipAuth');

          print('📦 Final Headers: ${options.headers}');
          print('📤 Request Data: ${options.data}');
          handler.next(options);
        },
        onResponse: (response, handler) {
          print('✅ Response [${response.statusCode}] → ${response.data}');
          handler.next(response);
        },
        onError: (e, handler) {
          print("❌ Dio Error Intercepted → ${e.type}");
          print("🧨 Message: ${e.message}");
          print("📛 Error: ${e.error}");
          if (e.response != null) {
            print("📥 Error Response Data: ${e.response?.data}");
            print("📥 Status Code: ${e.response?.statusCode}");
          }
          handler.next(e);
        },
      ),
    );
  }

  // Modified POST method
  Future<Response> post(
    String url, {
    Map<String, dynamic>? body,
    String? bearerToken,
    bool injectToken = true,
  }) async {
    try {
      print('📡 POST $url');

      final headers = <String, dynamic>{'Content-Type': 'application/json'};

      if (!injectToken) {
        headers['skipAuth'] = true; // 👈 important flag
      } else {
        final token = await _secure.read(key: 'token');
        if (token != null && token.isNotEmpty) {
          headers['Authorization'] = 'Bearer $token';
          print("✅ Injected Authorization Header");
        } else {
          print("❌ No token found");
        }
      }

      final response = await _dio.post(
        url,
        data: body == null ? null : jsonEncode(body),
        options: Options(headers: headers),
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
      print('📡 GET $url');
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
              'Accept': 'application/json',
              'User-Agent': 'FlutterApp/1.0', // optional
            },
    );
  }

  ApiException _handleDioError(DioException e) {
    print("🔥 Dio Error Type: ${e.type}");
    print("🔥 Dio Full Error: $e");

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
    } else if (e.type == DioExceptionType.unknown ||
        e.type == DioExceptionType.connectionError) {
      print("🚨 Dio UNKNOWN Error: ${e.error}");
      return NetworkException(); // or UnknownException()
    } else {
      return UnknownException();
    }
  }
}
