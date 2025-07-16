class CartItemModel {
  final int id;
  final int productId;
  final String name;
  final String price;
  final int quantity;
  final String image;

  CartItemModel({
    required this.id,
    required this.productId,
    required this.name,
    required this.price,
    required this.quantity,
    required this.image,
  });

  factory CartItemModel.fromJson(Map<String, dynamic> json) {
    return CartItemModel(
      id: json['id'],
      productId: json['product_id'],
      name: json['name'],
      price: json['price'],
      quantity: json['quantity'],
      image: json['image'],
    );
  }
}
