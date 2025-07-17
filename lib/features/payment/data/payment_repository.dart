import 'package:apnamall_ecommerce_app/core/network/api_client.dart';
import 'package:apnamall_ecommerce_app/core/network/api_endpoint.dart';
import 'package:apnamall_ecommerce_app/features/payment/data/model/payment_model.dart';
import 'package:apnamall_ecommerce_app/features/payment/bloc/payment_event.dart';
import 'package:dio/dio.dart';

class PaymentRepository {
  final ApiClient apiClient;

  PaymentRepository({required this.apiClient});

  Future<PaymentIntentModel> createPaymentIntent({
    required int amount,
    required String description,
    required CustomerDetails customerDetails,
    Map<String, dynamic>? metadata, // ✅ added
    String currency = 'inr',
  }) async {
    try {
      final body = {
        'amount': amount,
        'currency': currency,
        'description': description,
        'customerDetails': customerDetails.toJson(),
        if (metadata != null) 'metadata': metadata, // ✅ add this conditionally
      };

      final Response response = await apiClient.post(
        ApiEndpoint.createPaymentIntent,
        body: body,
        injectToken: false,
      );

      final data = response.data;
      return PaymentIntentModel.fromJson(data);
    } catch (e) {
      rethrow;
    }
  }
}
