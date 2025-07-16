part of 'cart_bloc.dart';

abstract class CartEvent {}

class AddToCartEvent extends CartEvent {
  final int productId;
  final int quantity;

  AddToCartEvent({required this.productId, required this.quantity});
}

class FetchCartEvent extends CartEvent {}

class DecrementQuantityEvent extends CartEvent {
  final int productId;
  final int quantity;

  DecrementQuantityEvent({required this.productId, required this.quantity});
}

class DeleteCartEvent extends CartEvent {
  final int cartId;

  DeleteCartEvent({required this.cartId});
}

class ResetCartMessageEvent extends CartEvent {}

class FetchCouponsEvent extends CartEvent {}

class ApplyCouponEvent extends CartEvent {
  final CouponModel coupon;

  ApplyCouponEvent(this.coupon);
}

class ClearCartEvent extends CartEvent {}

