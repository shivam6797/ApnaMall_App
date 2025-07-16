import 'package:apnamall_ecommerce_app/config/app_routes.dart';
import 'package:apnamall_ecommerce_app/features/profile/bloc/profile_bloc.dart';
import 'package:apnamall_ecommerce_app/features/profile/bloc/profile_event.dart';
import 'package:apnamall_ecommerce_app/features/profile/bloc/profile_state.dart';
import 'package:apnamall_ecommerce_app/features/profile/data/models/user_profile_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:apnamall_ecommerce_app/core/utils/shared_prefs.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          "👤 My Profile",
          style: TextStyle(
            color: Colors.black,
            fontFamily: "Poppins",
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
      ),
      body: BlocBuilder<ProfileBloc, ProfileState>(
        builder: (context, state) {
          if (state is ProfileLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is ProfileLoaded) {
            return _buildProfileBody(context, state.profile);
          } else if (state is ProfileError) {
            return Center(child: Text(state.message));
          } else {
            return const SizedBox.shrink();
          }
        },
      ),
    );
  }

  Widget _buildProfileBody(BuildContext context, UserProfileModel profile) {
    return RefreshIndicator(
      onRefresh: () async {
        context.read<ProfileBloc>().add(LoadUserProfileEvent());
      },
      child: FutureBuilder<Map<String, dynamic>?>(
        future: SharedPrefs.getUserProfile(),
        builder: (context, snapshot) {
          final address = snapshot.data?['address'] ?? "Not added";

          return SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Center(
                  child: CircleAvatar(
                    radius: 40,
                    backgroundColor: Colors.grey.shade100,
                    backgroundImage: profile.image.isNotEmpty
                        ? NetworkImage(profile.image)
                        : null,
                    child: profile.image.isEmpty
                        ? const Icon(Icons.person, size: 50, color: Colors.grey)
                        : null,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  profile.name,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  profile.email,
                  style: const TextStyle(color: Colors.black54),
                ),
                const SizedBox(height: 4),
                Text(
                  profile.mobile,
                  style: const TextStyle(color: Colors.black54),
                ),
                const SizedBox(height: 10),

                /// User Info Cards (excluding ID)
                _buildInfoCard(Icons.person_outline, "Name", profile.name),
                _buildInfoCard(Icons.email_outlined, "Email", profile.email),
                _buildInfoCard(Icons.phone_android, "Mobile", profile.mobile),
                _buildInfoCard(Icons.location_on_outlined, "Address", address),
                const SizedBox(height: 15),
                ElevatedButton.icon(
                  onPressed: () async {
                    final storage = const FlutterSecureStorage();
                    await storage.delete(key: 'token');
                    if (context.mounted) {
                      Navigator.pushReplacementNamed(
                        context,
                        AppRoutes.routeLogin,
                      );
                    }
                  },
                  icon: const Icon(Icons.logout),
                  label: const Text("Logout"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red.shade600,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32,
                      vertical: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildInfoCard(IconData icon, String title, String value) {
    return Card(
      color: const Color(0xFFF7F8FA),
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 2,
      child: ListTile(
        leading: Icon(icon, color: Colors.deepPurple),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
        subtitle: Text(value),
        trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 16),
      ),
    );
  }
}
