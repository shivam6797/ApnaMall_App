import 'package:apnamall_ecommerce_app/core/errors/api_exceptions.dart';
import 'package:apnamall_ecommerce_app/features/orders/data/models/order_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'order_event.dart';
import 'order_state.dart';

class OrderBloc extends Bloc<OrderEvent, OrderState> {
  final OrderRepository repository;

  OrderBloc({required this.repository}) : super(OrderInitial()) {
    on<CreateOrderEvent>(_onCreateOrder);
  }

  Future<void> _onCreateOrder(
    CreateOrderEvent event,
    Emitter<OrderState> emit,
  ) async {
    emit(OrderLoading());

    try {
      final message = await repository.createOrder(
        cartItems: event.cartItems,
        address: event.address,
        subtotal: event.subtotal,
        discount: event.discount,
        total: event.total,
      );
      emit(OrderSuccess(message));
    } on ApiException catch (e) {
      emit(OrderFailure(e.message));
    } catch (e) {
      emit(OrderFailure("Something went wrong"));
    }
  }
}
