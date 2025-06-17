// lib/features/auth/data/auth_api_client.dart
import 'dart:convert';

import 'package:apnamall_ecommerce_app/core/errors/api_exceptions.dart';
import 'package:apnamall_ecommerce_app/core/network/api_client.dart';
import 'package:apnamall_ecommerce_app/core/network/api_endpoint.dart';
import 'package:apnamall_ecommerce_app/features/auth/data/models/user_model.dart';

class AuthApiClient {
  final ApiClient _api;
  AuthApiClient(this._api);

  // ───────────────────────────────────────── SIGN‑UP
  Future<UserModel> signUp({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
    required String mobile,
  }) async {
    final res = await _api.post(
      ApiEndpoint.register,
      body: {
        "name": '$firstName $lastName',
        "mobile_number": int.parse(mobile),
        "email": email,
        "password": password,
      },
    );

    final Map<String, dynamic> json = _toJsonMap(res.data);

    if (json['status'] == true) {
      return UserModel.fromJson(json);
    }
    throw ApiException(json['message'] ?? 'Signup failed');
  }

  // ───────────────────────────────────────── LOGIN
  Future<UserModel> login({
    required String email,
    required String password,
  }) async {
    final res = await _api.post(
      ApiEndpoint.login,
      body: {"email": email, "password": password},
    );

    final Map<String, dynamic> json = _toJsonMap(res.data);

    if (json['status'] == true) {
      return UserModel.fromJson(json);
    }
    throw ApiException(json['message'] ?? 'Login failed');
  }

  // ───────────────────────────────────────── helper
  Map<String, dynamic> _toJsonMap(dynamic data) {
    // Some back‑ends send a raw JSON string — handle both cases.
    if (data is Map<String, dynamic>) return data;
    if (data is String) return jsonDecode(data) as Map<String, dynamic>;
    throw ApiException('Unexpected response format');
  }
}
