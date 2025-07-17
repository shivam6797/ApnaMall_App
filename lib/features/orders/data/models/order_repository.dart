import 'package:apnamall_ecommerce_app/core/errors/api_exceptions.dart';
import 'package:apnamall_ecommerce_app/core/network/api_client.dart';
import 'package:apnamall_ecommerce_app/core/network/api_endpoint.dart';
import 'package:apnamall_ecommerce_app/features/address/data/model/address_model.dart';
import 'package:apnamall_ecommerce_app/features/cart/data/model/cart_item_model.dart';

class OrderRepository {
  final ApiClient apiClient;

  OrderRepository({required this.apiClient});

  Future<String> createOrder({
    required List<CartItemModel> cartItems,
    required AddressModel address,
    required double subtotal,
    required double discount,
    required double total,
  }) async {
    try {
      final response = await apiClient.post(
        ApiEndpoint.createOrder,
        body: {
          "product_ids": cartItems.map((item) => item.productId).toList(),
          "subtotal": subtotal,
          "discount": discount,
          "total": total,
          "status": 1,
          "address": {
            "line": address.fullAddress,
            "city": address.city,
            "state": address.state,
            "postal_code": address.pinCode,
          },
        },
      );

      final data = response.data;
      if (data['status'] == true) {
        return data['message'] ?? "Order created successfully";
      } else {
        throw ApiException(data['message'] ?? "Failed to create order");
      }
    } on ApiException catch (e) {
      throw e;
    } catch (e) {
      throw UnknownException("Something went wrong while creating order");
    }
  }
}
