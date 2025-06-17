class ApiEndpoint {
  // API Endpoints for the E-commerce Application
  // Base URL for the API
  static const String baseUrl =
      'https://ecommerceapi.projectnest.online/ecommerce-api';

  // ---------- Auth ----------
  static const String register = '$baseUrl/user/registration';
  static const String login    = '$baseUrl/user/login';

  // ---------- Products ----------
  static const String products        = '$baseUrl/products';
  static String productById(int id)   => '$baseUrl/products/$id';

}
