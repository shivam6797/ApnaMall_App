import 'package:apnamall_ecommerce_app/features/address/data/model/address_model.dart';
import 'package:apnamall_ecommerce_app/features/cart/data/model/cart_item_model.dart';

abstract class OrderEvent {}

class CreateOrderEvent extends OrderEvent {
  final List<CartItemModel> cartItems;
  final AddressModel address;
  final double subtotal;
  final double discount;
  final double total;

  CreateOrderEvent({
    required this.cartItems,
    required this.address,
    required this.subtotal,
    required this.discount,
    required this.total,
  });
}
