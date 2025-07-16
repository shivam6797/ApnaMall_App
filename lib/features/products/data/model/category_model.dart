class CategoryResponse {
  final bool status;
  final String message;
  final List<Category> data;

  CategoryResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  factory CategoryResponse.fromJson(Map<String, dynamic> json) {
    return CategoryResponse(
      status: json['status'] ?? false,
      message: json['message'] ?? '',
      data: (json['data'] as List)
          .map((item) => Category.fromJson(item))
          .toList(),
    );
  }
}

class Category {
  final int id;
  final String name;
  final int status;
  final String createdAt;
  final String updatedAt;

  Category({
    required this.id,
    required this.name,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: int.tryParse(json['id'].toString()) ?? 0,
      name: json['name'] ?? '',
      status: int.tryParse(json['status'].toString()) ?? 0,
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
    );
  }
}
