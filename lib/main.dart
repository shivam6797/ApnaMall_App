import 'package:apnamall_ecommerce_app/config/app_routes.dart';
import 'package:apnamall_ecommerce_app/core/network/api_client.dart';
import 'package:apnamall_ecommerce_app/features/auth/bloc/auth_bloc.dart';
import 'package:apnamall_ecommerce_app/features/auth/data/auth_api_client.dart';
import 'package:apnamall_ecommerce_app/features/auth/data/auth_repository.dart';
import 'package:apnamall_ecommerce_app/features/cart/bloc/cart_bloc.dart';
import 'package:apnamall_ecommerce_app/features/cart/data/cart_repo.dart';
import 'package:apnamall_ecommerce_app/features/orders/bloc/order_bloc.dart';
import 'package:apnamall_ecommerce_app/features/orders/data/models/order_repository.dart';
import 'package:apnamall_ecommerce_app/features/payment/bloc/payment_bloc.dart';
import 'package:apnamall_ecommerce_app/features/payment/data/payment_repository.dart';
import 'package:apnamall_ecommerce_app/features/payment/screens/payment_screen.dart';
import 'package:apnamall_ecommerce_app/features/products/bloc/product_bloc.dart';
import 'package:apnamall_ecommerce_app/features/products/data/product_api_client.dart';
import 'package:apnamall_ecommerce_app/features/products/data/product_repo.dart';
import 'package:apnamall_ecommerce_app/features/profile/bloc/profile_bloc.dart';
import 'package:apnamall_ecommerce_app/features/profile/bloc/profile_event.dart';
import 'package:apnamall_ecommerce_app/features/profile/data/profile_repository.dart';
import 'package:apnamall_ecommerce_app/features/profile/screens/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_stripe/flutter_stripe.dart';

void main()async {
   WidgetsFlutterBinding.ensureInitialized();
  Stripe.publishableKey = 'pk_test_51NxV1VSAY82tTUyi83fkP9okCqo8UiLpX3WAWWJL6LIEkLCPIW6xLrZb4QGBM7FU5NwTwm63mIG6GgaM8DCovm3300Mk6AtIjr';
  runApp(
    MultiBlocProvider(
      providers: [
        // Add your Bloc providers here
        BlocProvider(
          create: (context) =>
              AuthBloc(repo: AuthRepositoryImpl(AuthApiClient(ApiClient()))),
        ),
        BlocProvider(
          create: (_) => ProductBloc(
            repo: ProductRepository(ProductApiClient(ApiClient())),
          ),
        ),
        BlocProvider(
          create: (_) => CartBloc(cartRepo: CartRepo(apiClient: ApiClient())),
        ),
        BlocProvider(
          create: (_) =>
              OrderBloc(repository: OrderRepository(apiClient: ApiClient())),
        ),
        BlocProvider(
          create: (_) => ProfileBloc(
            profileRepository: ProfileRepository(apiClient: ApiClient()),
          )..add(LoadUserProfileEvent()),
          child: ProfileScreen(),
        ),
        BlocProvider(
          create: (context) => PaymentBloc(
            paymentRepo: PaymentRepository(apiClient: ApiClient()),
          ),
          child: PaymentScreen(),
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
