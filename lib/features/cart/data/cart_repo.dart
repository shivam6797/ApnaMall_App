import 'package:apnamall_ecommerce_app/core/network/api_client.dart';
import 'package:apnamall_ecommerce_app/core/network/api_endpoint.dart';
import 'package:apnamall_ecommerce_app/features/cart/data/model/cart_item_model.dart';
import 'dart:convert';

import 'package:apnamall_ecommerce_app/features/cart/data/model/coupon_model.dart';

class CartRepo {
  final ApiClient apiClient;

  CartRepo({required this.apiClient});

  Future<String> addToCart(int productId, int quantity) async {
    final body = {"product_id": productId, "quantity": quantity};
    final response = await apiClient.post(ApiEndpoint.addtocart, body: body);
    print("RESPONSE TYPE: ${response.data.runtimeType}");
    print("RESPONSE: ${response.data}");
    final decodedData = jsonDecode(response.data);
    final statusRaw = decodedData['status'];
    final status = statusRaw is bool
        ? statusRaw
        : statusRaw.toString().toLowerCase() == 'true';
    if (status) {
      return decodedData['message'] ?? 'Added to cart';
    } else {
      throw Exception(decodedData['message'] ?? 'Add to cart failed');
    }
  }

  Future<List<CartItemModel>> viewCart() async {
    final response = await apiClient.get(ApiEndpoint.viewcart);
    final rawData = response.data;
    final data = rawData is String ? jsonDecode(rawData) : rawData;

    if (data['status'] == true) {
      List raw = data['data'];
      return raw.map((e) => CartItemModel.fromJson(e)).toList();
    } else {
      throw Exception(data['message'] ?? 'Failed to fetch cart');
    }
  }

  // 🔽 Decrement Quantity
  Future<String> decrementQuantity(int productId, int quantity) async {
    final body = {
      "product_id": productId,
      "quantity": quantity,
    };
    final response =
        await apiClient.post(ApiEndpoint.decrementQuantity, body: body);

    final data = response.data is String
        ? jsonDecode(response.data)
        : response.data;

    final statusRaw = data['status'];
    final status = statusRaw is bool
        ? statusRaw
        : statusRaw.toString().toLowerCase() == 'true';

    if (status) {
      return data['message'] ?? 'Quantity decreased';
    } else {
      throw Exception(data['message'] ?? 'Failed to decrease quantity');
    }
  }

  // ❌ Delete Cart Item
  Future<String> deleteCartItem(int cartId) async {
    final body = {
      "cart_id": cartId,
    };
    final response =
        await apiClient.post(ApiEndpoint.deleteCart, body: body);

    final data = response.data is String
        ? jsonDecode(response.data)
        : response.data;

    final statusRaw = data['status'];
    final status = statusRaw is bool
        ? statusRaw
        : statusRaw.toString().toLowerCase() == 'true';

    if (status) {
      return data['message'] ?? 'Deleted from cart';
    } else {
      throw Exception(data['message'] ?? 'Failed to delete cart');
    }
  }

  // Apply coupon 
  Future<List<CouponModel>> fetchCoupons() async {
    // Later replace with API call
    await Future.delayed(Duration(milliseconds: 500));
    return [
      CouponModel(code: "SAVE10", description: "Get ₹10 off on your order", discountAmount: 10, validTill: "2024-12-31"),
      CouponModel(code: "FREESHIP", description: "Free shipping on orders above ₹500", discountAmount: 0, validTill: "2024-12-31"),
      CouponModel(code: "BIG50", description: "Flat ₹50 off for new users", discountAmount: 50, validTill: "2024-12-31"),
    ];
  }
}
