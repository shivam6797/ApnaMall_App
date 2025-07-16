import 'package:flutter/material.dart';
import 'package:apnamall_ecommerce_app/features/cart/data/model/cart_item_model.dart';

class CartItemWidget extends StatelessWidget {
  final CartItemModel item;
  final bool isUpdating;
  final void Function()? onDecrement;
  final void Function()? onDelete;

  const CartItemWidget({
    super.key,
    required this.item,
    required this.isUpdating,
    this.onDecrement,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8),
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Image.network(item.image, width: 60, height: 60),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        item.name,
                        style: TextStyle(
                          fontSize: 13.5,
                          fontFamily: "Poppins",
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: isUpdating ? null : onDelete,
                      child: Icon(
                        Icons.delete_outline,
                        color: Color(0xffff650e),
                      ),
                    ),
                  ],
                ),
                Text("Product", style: TextStyle(color: Colors.grey)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "₹${double.tryParse(item.price)?.toStringAsFixed(2) ?? '0.00'}",
                      style: TextStyle(
                        fontFamily: "Poppins",
                        fontWeight: FontWeight.w700,
                        fontSize: 14,
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Row(
                        children: [
                          GestureDetector(
                            onTap: isUpdating ? null : onDecrement,
                            child: Icon(Icons.remove, size: 18),
                          ),
                          SizedBox(width: 12),
                          isUpdating
                              ? SizedBox(
                                  width: 12,
                                  height: 12,
                                  child: CircularProgressIndicator(strokeWidth: 2),
                                )
                              : Text(
                                  item.quantity.toString(),
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                          SizedBox(width: 12),
                          GestureDetector(
                            onTap: () {
                              // increment logic if needed
                            },
                            child: Icon(Icons.add, size: 18, color: Colors.grey.shade400),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
