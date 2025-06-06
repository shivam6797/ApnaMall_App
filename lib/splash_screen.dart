import 'dart:async';
import 'package:apnamall_ecommerce_app/config/app_routes.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 3), () {
      Navigator.pushReplacementNamed(context, AppRoutes.routeLogin);
    });
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
            // const CircularProgressIndicator(
            //   color: Color(0xffe78bbc),
            //   strokeWidth: 2.5,
            // ),
          ],
        ),
      ),
    );
  }
}
