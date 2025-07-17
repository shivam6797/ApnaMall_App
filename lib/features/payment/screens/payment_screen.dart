import 'package:apnamall_ecommerce_app/features/address/data/model/address_model.dart';
import 'package:apnamall_ecommerce_app/features/cart/bloc/cart_bloc.dart';
import 'package:apnamall_ecommerce_app/features/cart/data/model/cart_item_model.dart';
import 'package:apnamall_ecommerce_app/features/orders/bloc/order_bloc.dart';
import 'package:apnamall_ecommerce_app/features/orders/bloc/order_event.dart';
import 'package:apnamall_ecommerce_app/features/payment/bloc/payment_bloc.dart';
import 'package:apnamall_ecommerce_app/features/payment/bloc/payment_event.dart';
import 'package:apnamall_ecommerce_app/features/payment/bloc/payment_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_stripe/flutter_stripe.dart' as stripe;
import 'package:lottie/lottie.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({super.key});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  bool isProcessing = false;

  late AddressModel address;
  late List<CartItemModel> cartItems;
  late double subtotal;
  late double discount;
  late double total;

  void _startStripeFlow(String clientSecret) async {
    try {
      await stripe.Stripe.instance.initPaymentSheet(
        paymentSheetParameters: stripe.SetupPaymentSheetParameters(
          paymentIntentClientSecret: clientSecret,
          merchantDisplayName: 'ApnaMall',
          style: ThemeMode.system,
          googlePay: stripe.PaymentSheetGooglePay(
            merchantCountryCode: 'IN',
            currencyCode: 'INR',
            testEnv: true,
          ),
          allowsDelayedPaymentMethods: true,
        ),
      );

      await stripe.Stripe.instance.presentPaymentSheet();

      context.read<OrderBloc>().add(
        CreateOrderEvent(
          address: address,
          cartItems: cartItems,
          subtotal: subtotal,
          discount: discount,
          total: total,
        ),
      );

      context.read<CartBloc>().add(ClearCartEvent());

      _showResult(true);
    } catch (e) {
      print("Stripe PaymentSheet Error: $e");
      _showResult(false);
    }
  }

  void _showResult(bool isSuccess) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          isSuccess ? "✅ Payment Successful" : "❌ Payment Failed",
          style: const TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.bold,
            fontSize: 18,
            color: Colors.black,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: 160,
              width: 160,
              child: Lottie.asset(
                isSuccess
                    ? 'assets/lottie/success.json'
                    : 'assets/lottie/failure.json',
                fit: BoxFit.contain,
                repeat: true,
                animate: true,
              ),
            ),

            const SizedBox(height: 16),
            Text(
              isSuccess
                  ? "Thanks for your purchase!"
                  : "Something went wrong.\nPlease try again.",
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontFamily: 'Poppins',
                fontSize: 14,
                color: Colors.black87,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child:  Text(
              "OK",
              style: TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w600,
                fontSize: 15,
                color: Colors.teal.shade300,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)?.settings.arguments as Map?;
    address = args?['address'];
    cartItems = args?['cartItems'] ?? [];
    subtotal = args?['subtotal'] ?? 0;
    discount = args?['discount'] ?? 0;
    total = args?['total'] ?? 0;
    final user = args?['userProfile'] ?? {};

    return BlocListener<PaymentBloc, PaymentState>(
      listener: (context, state) {
        setState(() => isProcessing = state is PaymentLoading);

        if (state is PaymentSuccess) {
          _startStripeFlow(state.clientSecret);
        }

        if (state is PaymentFailure) {
          _showResult(false);
        }
      },
      child: Scaffold(
        backgroundColor: const Color(0xFFF5F5F5),
        appBar: AppBar(
          title: const Text(
            "Payment Summary",
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.bold,
              fontFamily: "Poppins",
            ),
          ),
          centerTitle: true,
          backgroundColor: Colors.teal.shade300,
          foregroundColor: Colors.white,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                "Customer Details",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  fontFamily: "Poppins",
                  color: Colors.teal.shade300,
                ),
              ),
              const SizedBox(height: 10),
              Card(
                color: Colors.grey.shade100,
                elevation: 3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "👤 Name: ",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 13.5,
                              fontFamily: "Poppins",
                              color: Colors.black,
                            ),
                          ),
                          Expanded(
                            child: Text(
                              user['name'] ?? '-',
                              style: const TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize: 13.5,
                                fontFamily: "Poppins",
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "📧 Email: ",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 13.5,
                              fontFamily: "Poppins",
                              color: Colors.black,
                            ),
                          ),
                          Expanded(
                            child: Text(
                              user['email'] ?? '-',
                              style: const TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize: 13.5,
                                fontFamily: "Poppins",
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "🏠 Address: ",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 13.5,
                              fontFamily: "Poppins",
                              color: Colors.black,
                            ),
                          ),
                          Expanded(
                            child: Text(
                              address.fullAddress,
                              style: const TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize: 13.5,
                                fontFamily: "Poppins",
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 24),
              Text(
                "Cart Summary",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  fontFamily: "Poppins",
                  color: Colors.teal.shade300,
                ),
              ),
              const SizedBox(height: 12),
              ...cartItems.map((item) {
                return Card(
                  color: Colors.grey.shade100,
                  elevation: 2,
                  margin: const EdgeInsets.symmetric(vertical: 6),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: ListTile(
                    leading: Icon(
                      Icons.shopping_cart,
                      color: Colors.teal.shade300,
                    ),
                    title: Text(
                      item.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        color: Colors.black,
                        fontFamily: "Poppins",
                        fontSize: 14,
                      ),
                    ),
                    trailing: Text(
                      "₹${item.price}",
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                        fontFamily: "Poppins",
                        fontSize: 12,
                      ),
                    ),
                  ),
                );
              }),
              const SizedBox(height: 12),
              Card(
                color: Colors.grey.shade100,
                elevation: 3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "Subtotal",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontFamily: "Poppins",
                              fontSize: 14,
                              color: Colors.black,
                            ),
                          ),
                          Text(
                            "₹$subtotal",
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontFamily: "Poppins",
                              fontSize: 14,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "Discount",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontFamily: "Poppins",
                              fontSize: 14,
                              color: Colors.black,
                            ),
                          ),
                          Text(
                            "- ₹$discount",
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontFamily: "Poppins",
                              fontSize: 14,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "Total",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontFamily: "Poppins",
                              fontSize: 15,
                              color: Colors.black,
                            ),
                          ),
                          Text(
                            "₹$total",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontFamily: "Poppins",
                              fontSize: 16,
                              color: Colors.teal.shade400,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 30),
              isProcessing
                  ? const Center(child: CircularProgressIndicator())
                  : ElevatedButton.icon(
                      icon: const Icon(Icons.payment),
                      label: const Text("Pay with Stripe"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.teal.shade300,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 16,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        textStyle: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      onPressed: () {
                        final fullAddress = address.fullAddress;
                        final parts = fullAddress
                            .split(',')
                            .map((e) => e.trim())
                            .toList();

                        final city = parts.length >= 3
                            ? parts[parts.length - 3]
                            : 'Unknown';
                        final state = parts.length >= 2
                            ? parts[parts.length - 2]
                            : 'Unknown';
                        final postalCode = parts.length >= 1
                            ? RegExp(
                                    r'\d{6}',
                                  ).firstMatch(parts.last)?.group(0) ??
                                  '000000'
                            : '000000';

                        final userName = user['name'] ?? 'Guest';
                        final userEmail = user['email'] ?? 'test@example.com';
                        final userPhone =
                            user['mobile_number']?.toString() ?? '';
                        final summary =
                            "Order by $userName - ${cartItems.length} item(s)";

                        context.read<PaymentBloc>().add(
                          CreatePaymentIntentEvent(
                            amount: (total * 100).toInt(),
                            description: summary,
                            customerDetails: CustomerDetails(
                              name: userName,
                              email: userEmail,
                              phone: userPhone,
                              description: summary,
                              address: CustomerAddress(
                                line1: fullAddress,
                                city: city,
                                state: state,
                                postalCode: postalCode,
                                country: 'IN',
                              ),
                            ),
                            metadata: {
                              "order_summary": summary,
                              "phone": userPhone,
                            },
                          ),
                        );
                      },
                    ),
              const SizedBox(height: 16),
              const Text(
                "Supports Card, UPI, NetBanking (test mode)",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
