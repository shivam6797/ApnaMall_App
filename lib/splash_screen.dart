import 'dart:async';
import 'package:apnamall_ecommerce_app/config/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 3), () {
      checkLoginStatus();
    });
  }

  void checkLoginStatus() async {
    final token = await _secureStorage.read(key: 'token');
     print("hello token $token");
    if (token != null && token.isNotEmpty) {
      // User is logged in
      Navigator.pushReplacementNamed(
        context,
        AppRoutes.routeMain,
      ); // or your home route
    } else {
      // User is not logged in
      Navigator.pushReplacementNamed(context, AppRoutes.routeLogin);
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/apnamall_logo.png',
              height: size.height * 0.25,
              fit: BoxFit.contain,
            ),
          ],
        ),
      ),
    );
  }
}
