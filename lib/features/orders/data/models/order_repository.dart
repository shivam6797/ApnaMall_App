import 'package:apnamall_ecommerce_app/core/errors/api_exceptions.dart';
import 'package:apnamall_ecommerce_app/core/network/api_client.dart';
import 'package:apnamall_ecommerce_app/core/network/api_endpoint.dart';

class OrderRepository {
  final ApiClient apiClient;

  OrderRepository({required this.apiClient});

  Future<String> createOrder() async {
    try {
      final response = await apiClient.post(
        ApiEndpoint.createOrder,
        body: {
          "product_id": [],
          "status": 1, // always 1 for "ordered"
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
