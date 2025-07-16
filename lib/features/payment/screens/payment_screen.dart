import 'package:apnamall_ecommerce_app/features/payment/bloc/payment_bloc.dart';
import 'package:apnamall_ecommerce_app/features/payment/bloc/payment_event.dart';
import 'package:apnamall_ecommerce_app/features/payment/bloc/payment_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:lottie/lottie.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({super.key});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  bool isProcessing = false;

  void _startStripeFlow(String clientSecret) async {
    try {
      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          paymentIntentClientSecret: clientSecret,
          merchantDisplayName: 'ApnaMall',
          style: ThemeMode.system,
          googlePay: PaymentSheetGooglePay(
            merchantCountryCode: 'IN',
            currencyCode: 'INR',
            testEnv: true,
          ),
          allowsDelayedPaymentMethods: true,
        ),
      );

      await Stripe.instance.presentPaymentSheet();

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
        title: Text(isSuccess ? "✅ Payment Successful" : "❌ Payment Failed"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Lottie.asset(
              isSuccess
                  ? 'assets/lottie/success.json'
                  : 'assets/lottie/failure.json',
              width: 120,
              repeat: false,
            ),
            const SizedBox(height: 12),
            Text(
              isSuccess
                  ? "Thanks for your purchase!"
                  : "Something went wrong. Please try again.",
              textAlign: TextAlign.center,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
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
        appBar: AppBar(title: const Text("Payment"), centerTitle: true),
        body: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.shopping_cart_checkout,
                size: 80,
                color: Colors.deepPurple,
              ),
              const SizedBox(height: 16),
              const Text(
                "Get Premium Access\n₹49 only",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 40),
              isProcessing
                  ? const CircularProgressIndicator()
                  : SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        icon: const Icon(Icons.payment),
                        label: const Text("Pay with Stripe"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.deepPurple,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 14,
                          ),
                          textStyle: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        onPressed: () {
                          context.read<PaymentBloc>().add(
                            CreatePaymentIntentEvent(
                              amount: 4999,
                              description: 'Premium Membership',
                              customerDetails: CustomerDetails(
                                name: 'Rahul Singh',
                                email: 'rahul@example.com',
                                address: CustomerAddress(
                                  line1: '221B Baker Street',
                                  city: 'Delhi',
                                  state: 'DL',
                                  postalCode: '110001',
                                  country: 'IN',
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
              const SizedBox(height: 20),
              const Text(
                "Supports Card, UPI, NetBanking (test)",
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
