import 'package:apnamall_ecommerce_app/features/address/screens/add_address_screens.dart';
import 'package:apnamall_ecommerce_app/features/address/screens/saved_address_screen.dart';
import 'package:apnamall_ecommerce_app/features/auth/screens/login_screen.dart';
import 'package:apnamall_ecommerce_app/features/auth/screens/signup_screen.dart';
import 'package:apnamall_ecommerce_app/features/cart/screens/cart_screen.dart';
import 'package:apnamall_ecommerce_app/features/orders/screens/order_success_screen.dart';
import 'package:apnamall_ecommerce_app/features/payment/screens/payment_screen.dart';
import 'package:apnamall_ecommerce_app/features/products/screens/product_detail_screen.dart';
import 'package:apnamall_ecommerce_app/features/products/screens/product_home_screen.dart';
import 'package:apnamall_ecommerce_app/main_screen.dart';
import 'package:apnamall_ecommerce_app/splash_screen.dart';
import 'package:flutter/material.dart';

class AppRoutes {
  static const String routeSplash = "/";
  static const String routeLogin = "/login";
  static const String routeSignup = "/signup";
  static const String routeHome = "/home";
  static const String routeMain = "/main";
  static const String routeProductDetail = "/product-detail";
  static const String routeCart = "/cart";
  static const String routeAddAddress = "/add-address";
  static const String routeSavedAddress = "/saved-address";
  static const String routePayment = "/payment";
  static const String routeOrderSuccess = "/order-success";





  static Map<String, WidgetBuilder> getRoutes() => {
    routeSplash: (context) => SplashScreen(),
    routeLogin: (context) => LoginScreen(),
    routeSignup: (context) => SignUpScreen(),
    routeMain: (context) => MainScreen(),
    routeHome: (context) => HomeScreen(),
    routeProductDetail: (context) => ProductDetailScreen(),
    routeCart: (context) => CartScreen(),
    routeAddAddress: (context) => AddAddressScreen(),
    routeSavedAddress: (context) => SavedAddressScreen(),
    routePayment: (context) => PaymentScreen(),
    routeOrderSuccess: (context) => OrderSuccessScreen(),

  };
}
