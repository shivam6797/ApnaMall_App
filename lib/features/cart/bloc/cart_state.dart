import 'package:equatable/equatable.dart';
import 'package:apnamall_ecommerce_app/features/cart/data/model/cart_item_model.dart';
import 'package:apnamall_ecommerce_app/features/cart/data/model/coupon_model.dart';

abstract class CartState extends Equatable {
  @override
  List<Object?> get props => [];
}

class CartInitial extends CartState {}

class CartLoading extends CartState {}

class CartActionInProgress extends CartState {
  final List<CartItemModel> cartItems;
  final int updatingProductId;

  CartActionInProgress({
    required this.cartItems,
    required this.updatingProductId,
  });
}

class CartSuccess extends CartState {
  final String message;
  final List<CartItemModel> cartItems;
  final String messageId;
  final List<CouponModel> coupons;
  final CouponModel? appliedCoupon;
  final double subtotal;
  final double total;

  CartSuccess({
    required this.message,
    required this.cartItems,
    this.messageId = '',
    this.coupons = const [],
    this.appliedCoupon,
    this.subtotal = 0,
    this.total = 0,
  });

  @override
  List<Object?> get props => [
    messageId,
    cartItems,
    coupons,
    appliedCoupon,
    subtotal,
    total,
  ];
}

class CartFailure extends CartState {
  final String error;

  CartFailure(this.error);

  @override
  List<Object?> get props => [error];
}
