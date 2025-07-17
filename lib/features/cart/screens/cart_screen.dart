import 'package:apnamall_ecommerce_app/config/app_routes.dart';
import 'package:apnamall_ecommerce_app/core/utils/shared_prefs.dart';
import 'package:apnamall_ecommerce_app/core/widgets/cart/cartItem_widget.dart';
import 'package:apnamall_ecommerce_app/features/cart/data/model/coupon_model.dart';
import 'package:coupon_uikit/coupon_uikit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:apnamall_ecommerce_app/features/cart/bloc/cart_bloc.dart';
import 'package:apnamall_ecommerce_app/features/cart/bloc/cart_state.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  String? lastMessageId;

  @override
  void initState() {
    super.initState();
    context.read<CartBloc>().add(FetchCartEvent());
  }

  void _showSnack(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 2),
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF8F8F8),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.only(left: 16),
          child: InkWell(
            borderRadius: BorderRadius.circular(30),
            onTap: () {
              Navigator.maybePop(context);
            },
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)],
              ),
              child: Icon(Icons.chevron_left, color: Colors.black, size: 30),
            ),
          ),
        ),
        centerTitle: true,
        title: Text(
          "My Cart",
          style: TextStyle(
            color: Colors.black,
            fontFamily: "Poppins",
            fontWeight: FontWeight.w700,
            fontSize: 18,
          ),
        ),
      ),
      body: BlocConsumer<CartBloc, CartState>(
        listenWhen: (prev, curr) {
          if (curr is CartSuccess &&
              curr.message.isNotEmpty &&
              curr.messageId != lastMessageId) {
            return true;
          }
          if (curr is CartFailure) return true;
          return false;
        },
        listener: (context, state) {
          final isCartScreen =
              ModalRoute.of(context)?.settings.name == AppRoutes.routeCart;
          if (isCartScreen) {
            if (state is CartSuccess && state.message.isNotEmpty) {
              _showSnack(state.message);
              lastMessageId = state.messageId;
              context.read<CartBloc>().add(ResetCartMessageEvent());
            } else if (state is CartFailure) {
              _showSnack(state.error);
            }
          }
        },
        builder: (context, state) {
          if (state is CartLoading) {
            return Center(child: CircularProgressIndicator());
          }

          if (state is CartSuccess || state is CartActionInProgress) {
            final items = (state is CartSuccess)
                ? state.cartItems
                : (state as CartActionInProgress).cartItems;
            final updatingId = state is CartActionInProgress
                ? state.updatingProductId
                : null;

            final subtotal = (state is CartSuccess) ? state.subtotal : 0.0;
            final discount =
                (state is CartSuccess && state.appliedCoupon != null)
                ? state.appliedCoupon!.discountAmount
                : 0.0;
            final total = subtotal - discount;

            if (items.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Lottie.asset('assets/lottie/empty_cart.json', width: 200),
                    const SizedBox(height: 16),
                    Text(
                      (state is CartSuccess && state.message.isNotEmpty)
                          ? state.message
                          : "Your cart is empty!",
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Poppins',
                      ),
                    ),
                  ],
                ),
              );
            }

            return Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: items.length,
                    padding: EdgeInsets.all(16),
                    itemBuilder: (_, index) {
                      final item = items[index];
                      final isUpdating = item.productId == updatingId;

                      return CartItemWidget(
                        item: item,
                        isUpdating: isUpdating,
                        onDecrement: () {
                          context.read<CartBloc>().add(
                            DecrementQuantityEvent(
                              productId: item.productId,
                              quantity: 1,
                            ),
                          );
                        },
                        onDelete: () {
                          context.read<CartBloc>().add(
                            DeleteCartEvent(cartId: item.id),
                          );
                        },
                      );
                    },
                  ),
                ),
                buildBottomSheet(context, state, subtotal, discount, total),
              ],
            );
          }

          return Center(
            heightFactor: 2.8,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Lottie.asset(
                  'assets/lottie/empty_cart.json',
                  width: 200,
                  height: 200,
                ),
                const Text(
                  "Your cart is empty!",
                  style: TextStyle(
                    fontSize: 16,
                    height: 0.1,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Poppins',
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget buildBottomSheet(
    BuildContext context,
    CartState state,
    double subtotal,
    double discount,
    double total,
  ) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 6)],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          buildCouponBox(context),
          SizedBox(height: 12),
          buildPriceRow("Subtotal", "₹${subtotal.toStringAsFixed(2)}"),
          buildPriceRow("Discount", "- ₹${discount.toStringAsFixed(2)}"),
          Divider(),
          buildPriceRow("Total", "₹${total.toStringAsFixed(2)}"),
          SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () async {
                if (state is CartSuccess && state.cartItems.isNotEmpty) {
                  final address = await SharedPrefs.getSelectedAddress();
                  final userProfile =
                      await SharedPrefs.getUserProfile(); // 👈 Fetch user profile

                  if (address == null) {
                    Navigator.pushNamed(context, AppRoutes.routeAddAddress);
                  } else {
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      backgroundColor: Colors.transparent,
                      builder: (context) {
                        return Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(24),
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black12,
                                blurRadius: 10,
                                offset: Offset(0, -4),
                              ),
                            ],
                          ),
                          child: SafeArea(
                            top: false,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  width: 40,
                                  height: 5,
                                  margin: const EdgeInsets.only(bottom: 16),
                                  decoration: BoxDecoration(
                                    color: Colors.grey[400],
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                Text(
                                  "Use saved address?",
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: "Poppins",
                                  ),
                                ),
                                const SizedBox(height: 12),
                                Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    color: Colors.grey[100],
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        address.fullAddress,
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 24),
                                ElevatedButton.icon(
                                  onPressed: () {
                                    Navigator.pop(context);
                                    Navigator.pushNamed(
                                      context,
                                      AppRoutes.routePayment,
                                      arguments: {
                                        'address': address,
                                        'cartItems': state.cartItems,
                                        'subtotal': subtotal,
                                        'discount': discount,
                                        'total': total,
                                        'appliedCoupon': state.appliedCoupon,
                                        'userProfile':
                                            userProfile, // 👈 Passed here
                                      },
                                    );
                                  },
                                  icon: const Icon(Icons.check),
                                  label: const Text("Yes, use this address"),
                                  style: ElevatedButton.styleFrom(
                                    minimumSize: const Size.fromHeight(50),
                                    backgroundColor: Colors.green,
                                    foregroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 10),
                                OutlinedButton.icon(
                                  onPressed: () {
                                    Navigator.pop(context);
                                    Navigator.pushNamed(
                                      context,
                                      AppRoutes.routeAddAddress,
                                    );
                                  },
                                  icon: const Icon(Icons.edit_location_alt),
                                  label: const Text("No, change address"),
                                  style: OutlinedButton.styleFrom(
                                    backgroundColor: Colors.white,
                                    foregroundColor: Colors.black,
                                    minimumSize: const Size.fromHeight(50),
                                    side: BorderSide(color: Colors.purple),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 10),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  }
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xffff650e),
                padding: EdgeInsets.symmetric(vertical: 16),
              ),
              child: Text(
                "Checkout",
                style: TextStyle(
                  fontFamily: "Poppins",
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildCouponBox(BuildContext context) {
    return InkWell(
      onTap: () {
        context.read<CartBloc>().add(FetchCouponsEvent());
        _showCouponBottomSheet();
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            Icon(Icons.discount, color: Color(0xffff650e)),
            SizedBox(width: 12),
            Text(
              "Apply Coupon",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Color(0xffff650e),
              ),
            ),
            Spacer(),
            Icon(Icons.chevron_right, color: Colors.grey),
          ],
        ),
      ),
    );
  }

  void _showCouponBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      isDismissible: true,
      backgroundColor: Colors.transparent,
      builder: (_) {
        return DraggableScrollableSheet(
          initialChildSize: 0.7,
          maxChildSize: 0.9,
          minChildSize: 0.5,
          builder: (context, scrollController) {
            return Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 10,
                    offset: Offset(0, -4),
                  ),
                ],
              ),
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: BlocBuilder<CartBloc, CartState>(
                builder: (context, state) {
                  if (state is CartSuccess && state.coupons.isNotEmpty) {
                    final coupons = state.coupons;

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: Container(
                            width: 40,
                            height: 4,
                            margin: EdgeInsets.only(bottom: 12),
                            decoration: BoxDecoration(
                              color: Colors.grey[600],
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                        ),
                        Text(
                          "Available Coupons",
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(height: 16),
                        Expanded(
                          child: ListView.builder(
                            controller: scrollController,
                            itemCount: coupons.length,
                            itemBuilder: (_, index) {
                              final coupon = coupons[index];
                              final isSelected =
                                  state.appliedCoupon?.code == coupon.code;

                              return GestureDetector(
                                onTap: () {
                                  Navigator.pop(context);
                                  context.read<CartBloc>().add(
                                    ApplyCouponEvent(coupon),
                                  );
                                },
                                child: Padding(
                                  padding: const EdgeInsets.only(bottom: 16),
                                  child: buildCouponCard(
                                    coupon,
                                    isSelected: isSelected,
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    );
                  } else if (state is CartLoading) {
                    return Center(child: CircularProgressIndicator());
                  } else {
                    return Center(
                      child: Text(
                        "No coupons available",
                        style: TextStyle(fontSize: 16),
                      ),
                    );
                  }
                },
              ),
            );
          },
        );
      },
    );
  }

  Widget buildCouponCard(CouponModel coupon, {required bool isSelected}) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: isSelected ? Color(0xff2E8A85) : Colors.transparent,
          width: 2,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: CouponCard(
        height: 100,
        backgroundColor: Color(0xffD5F5F3),
        curvePosition: 120,
        borderRadius: 12,
        curveAxis: Axis.vertical,
        firstChild: Container(
          color: Color(0xFF2E8A85),
          padding: EdgeInsets.symmetric(horizontal: 12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "${coupon.discountAmount.toStringAsFixed(0)}%",
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              Text(
                "OFF",
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 4),
              Text(
                coupon.description.toUpperCase(),
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  fontSize: 8,
                  color: Colors.white,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
        ),
        secondChild: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Coupon Code",
                style: GoogleFonts.poppins(
                  fontSize: 11,
                  color: Colors.grey.shade700,
                ),
              ),
              SizedBox(height: 2),
              Text(
                coupon.code,
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2E8A85),
                ),
              ),
              SizedBox(height: 4),
              Text(
                "Valid Till - ${coupon.validTill ?? "N/A"}",
                style: GoogleFonts.poppins(
                  fontSize: 11,
                  color: Colors.grey.shade600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildPriceRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
          ),
          Text(
            value,
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
