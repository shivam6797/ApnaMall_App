class ProductResponse {
  final bool status;
  final String message;
  final List<Product> data;

  ProductResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  factory ProductResponse.fromJson(Map<String, dynamic> json) {
    return ProductResponse(
      status: json['status'] ?? false,
      message: json['message'] ?? '',
      data: (json['data'] as List)
          .map((item) => Product.fromJson(item))
          .toList(),
    );
  }
}

class Product {
  final int id;
  final String name;
  final String price;
  final String image;
  final int categoryId;
  final int status;
  final String createdAt;
  final String updatedAt;

  Product({
    required this.id,
    required this.name,
    required this.price,
    required this.image,
    required this.categoryId,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      name: json['name'],
      price: json['price'],
      image: json['image'],
      categoryId: json['category_id'],
      status: json['status'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }
}
