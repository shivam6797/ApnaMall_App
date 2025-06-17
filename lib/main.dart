import 'package:apnamall_ecommerce_app/config/app_routes.dart';
import 'package:apnamall_ecommerce_app/core/network/api_client.dart';
import 'package:apnamall_ecommerce_app/features/auth/bloc/auth_bloc.dart';
import 'package:apnamall_ecommerce_app/features/auth/data/auth_api_client.dart';
import 'package:apnamall_ecommerce_app/features/auth/data/auth_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main(){
  runApp(
    MultiBlocProvider(
      providers: [
        // Add your Bloc providers here
        BlocProvider(
          create: (context) =>
              AuthBloc(repo: AuthRepositoryImpl(AuthApiClient(ApiClient()))),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'ApnaMall App',
      
      theme: ThemeData(
        fontFamily: "Poppins",
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      initialRoute: AppRoutes.routeSplash,
      routes: AppRoutes.getRoutes(),
    );
  }
}
