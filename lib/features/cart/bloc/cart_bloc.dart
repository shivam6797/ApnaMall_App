import 'package:apnamall_ecommerce_app/features/cart/data/model/cart_item_model.dart';
import 'package:apnamall_ecommerce_app/features/cart/data/model/coupon_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:apnamall_ecommerce_app/features/cart/data/cart_repo.dart';
import 'package:apnamall_ecommerce_app/features/cart/bloc/cart_state.dart';
part 'cart_event.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  final CartRepo cartRepo;

  List<CouponModel> _coupons = [];
  CouponModel? _appliedCoupon;

  CartBloc({required this.cartRepo}) : super(CartInitial()) {
    on<AddToCartEvent>(_onAddToCart);
    on<FetchCartEvent>(_onFetchCart);
    on<DecrementQuantityEvent>(_onDecrementQuantity);
    on<DeleteCartEvent>(_onDeleteCartItem);
    on<ResetCartMessageEvent>(_onResetCartMessage);
    on<FetchCouponsEvent>(_onFetchCoupons);
    on<ApplyCouponEvent>(_onApplyCoupon);
    on<ClearCartEvent>((event, emit) {
      emit(
        CartSuccess(
          cartItems: [],
          message: "Your cart has been cleared!",
          messageId: DateTime.now().toIso8601String(),
          subtotal: 0.0,
          appliedCoupon: null,
        ),
      );
    });
  }

  List<CartItemModel> _getCurrentCartItems() {
    return state is CartSuccess ? (state as CartSuccess).cartItems : [];
  }

  double _calculateSubtotal(List<CartItemModel> cartItems) {
    return cartItems.fold(0, (total, item) {
      final price = double.tryParse(item.price) ?? 0;
      return total + (price * item.quantity);
    });
  }

  Future<void> _onAddToCart(
    AddToCartEvent event,
    Emitter<CartState> emit,
  ) async {
    emit(
      CartActionInProgress(
        cartItems: _getCurrentCartItems(),
        updatingProductId: event.productId,
      ),
    );
    try {
      final message = await cartRepo.addToCart(event.productId, event.quantity);
      final cartItems = await cartRepo.viewCart();
      emit(_buildSuccessState(cartItems, message));
    } catch (e) {
      emit(CartFailure("Failed to add item: ${e.toString()}"));
    }
  }

  Future<void> _onFetchCart(
    FetchCartEvent event,
    Emitter<CartState> emit,
  ) async {
    emit(CartLoading());
    try {
      final cartItems = await cartRepo.viewCart();
      emit(_buildSuccessState(cartItems, ''));
    } catch (e) {
      emit(CartFailure("Failed to load cart: ${e.toString()}"));
    }
  }

  Future<void> _onDecrementQuantity(
    DecrementQuantityEvent event,
    Emitter<CartState> emit,
  ) async {
    emit(
      CartActionInProgress(
        cartItems: _getCurrentCartItems(),
        updatingProductId: event.productId,
      ),
    );
    try {
      final message = await cartRepo.decrementQuantity(
        event.productId,
        event.quantity,
      );
      final cartItems = await cartRepo.viewCart();
      emit(_buildSuccessState(cartItems, message));
    } catch (e) {
      emit(CartFailure("Failed to update quantity: ${e.toString()}"));
    }
  }

  Future<void> _onDeleteCartItem(
    DeleteCartEvent event,
    Emitter<CartState> emit,
  ) async {
    emit(
      CartActionInProgress(
        cartItems: _getCurrentCartItems(),
        updatingProductId: event.cartId,
      ),
    );
    try {
      final message = await cartRepo.deleteCartItem(event.cartId);
      final cartItems = await cartRepo.viewCart();
      emit(_buildSuccessState(cartItems, message));
    } catch (e) {
      emit(CartFailure("Failed to delete item: ${e.toString()}"));
    }
  }

  void _onResetCartMessage(
    ResetCartMessageEvent event,
    Emitter<CartState> emit,
  ) {
    if (state is CartSuccess) {
      final current = state as CartSuccess;
      emit(_buildSuccessState(current.cartItems, ''));
    }
  }

  // 🔽 New: Fetch Coupons
  Future<void> _onFetchCoupons(
    FetchCouponsEvent event,
    Emitter<CartState> emit,
  ) async {
    try {
      _coupons = await cartRepo.fetchCoupons();
      if (state is CartSuccess) {
        final current = state as CartSuccess;
        emit(_buildSuccessState(current.cartItems, 'Coupons fetched'));
      }
    } catch (e) {
      emit(CartFailure("Failed to fetch coupons: ${e.toString()}"));
    }
  }

  // 🔽 New: Apply Coupon
  Future<void> _onApplyCoupon(
    ApplyCouponEvent event,
    Emitter<CartState> emit,
  ) async {
    _appliedCoupon = event.coupon;
    if (state is CartSuccess) {
      final current = state as CartSuccess;
      emit(
        _buildSuccessState(
          current.cartItems,
          'Coupon applied: ${event.coupon.code}',
        ),
      );
    }
  }

  // 🔁 Util: Build CartSuccess state
  CartSuccess _buildSuccessState(
    List<CartItemModel> cartItems,
    String message,
  ) {
    final subtotal = _calculateSubtotal(cartItems);
    final discount = _appliedCoupon?.discountAmount ?? 0;
    final total = (subtotal - discount).clamp(0, double.infinity).toDouble();

    return CartSuccess(
      message: message,
      cartItems: cartItems,
      messageId: DateTime.now().millisecondsSinceEpoch.toString(),
      coupons: _coupons,
      appliedCoupon: _appliedCoupon,
      subtotal: subtotal,
      total: total,
    );
  }
}
