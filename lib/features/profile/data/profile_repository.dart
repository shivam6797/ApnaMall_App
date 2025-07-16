import 'dart:convert';
import 'package:apnamall_ecommerce_app/core/network/api_client.dart';
import 'package:apnamall_ecommerce_app/core/network/api_endpoint.dart';
import 'package:apnamall_ecommerce_app/features/profile/data/models/user_profile_model.dart';
import 'package:apnamall_ecommerce_app/core/utils/shared_prefs.dart';
import 'package:dio/dio.dart';

class ProfileRepository {
  final ApiClient apiClient;
  
  ProfileRepository({required this.apiClient});

  Future<UserProfileModel> fetchUserProfile() async {
    try {
      final Response response = await apiClient.post(ApiEndpoint.userProfile);

      final decoded = response.data is String
          ? jsonDecode(response.data)
          : response.data;

      print("✅ Decoded Profile Response: $decoded");

      if (decoded['status'] == true && decoded['data'] != null) {
        final userProfile = UserProfileModel.fromJson(decoded['data']);
        await SharedPrefs.setUserProfile(decoded['data']);
        return userProfile;
      } else {
        throw Exception(decoded['message'] ?? "Failed to load profile");
      }
    } catch (e) {
      print("❌ Error in fetchUserProfile: $e");
      rethrow;
    }
  }
}
