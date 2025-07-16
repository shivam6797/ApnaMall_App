class ApiEndpoint {
  // API Endpoints for the E-commerce Application
  // Base URL for the API
  static const String baseUrl =
      'https://ecommerceapi.projectnest.online/ecommerce-api';

  // ---------- Auth ----------
  static const String register = '$baseUrl/user/registration';
  static const String login    = '$baseUrl/user/login';

  // ---------- Products ----------
  static const String products = '$baseUrl/products';
  static const String categories = '$baseUrl/categories';

  // ---------- Cart ----------
  static const String addtocart = '$baseUrl/add-to-cart';
  static const String viewcart = '$baseUrl/product/view-cart';
  static const String decrementQuantity = '$baseUrl/product/decrement-quantity';
  static const String deleteCart = '$baseUrl/product/delete-cart';

  // ---------- Orders ----------
  static const String createOrder = '$baseUrl/product/create-order';


 // ---------- Profile ----------
  static const String userProfile = '$baseUrl/user/profile';


  // ---------- Payments ----------
static const String createPaymentIntent = 'https://stripe-backend-ye9d.onrender.com/create-payment-intent';


}
  