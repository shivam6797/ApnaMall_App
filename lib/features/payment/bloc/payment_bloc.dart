import 'package:apnamall_ecommerce_app/features/payment/data/payment_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'payment_event.dart';
import 'payment_state.dart';

class PaymentBloc extends Bloc<PaymentEvent, PaymentState> {
  final PaymentRepository paymentRepo;

  PaymentBloc({required this.paymentRepo}) : super(PaymentInitial()) {
    on<CreatePaymentIntentEvent>((event, emit) async {
      emit(PaymentLoading());

      try {
        final paymentIntent = await paymentRepo.createPaymentIntent(
          amount: event.amount,
          description: event.description,
          customerDetails: event.customerDetails,
        );

        emit(PaymentSuccess(paymentIntent.clientSecret));
      } catch (e) {
        emit(PaymentFailure(e.toString()));
      }
    });
  }
}
