import 'package:apnamall_ecommerce_app/features/products/data/model/category_model.dart';
import 'package:apnamall_ecommerce_app/features/products/data/model/product_model.dart';
import 'product_api_client.dart';
import 'package:apnamall_ecommerce_app/core/errors/api_exceptions.dart';

class ProductRepository {
  final ProductApiClient api;
  ProductRepository(this.api);

  Future<List<Category>> getCategories() async {
    final json = await api.fetchCategories();
    if (json['status'] == true) {
      return CategoryResponse.fromJson(json).data;
    }
    throw ApiException(json['message'] ?? 'Category fetch failed');
  }
  
  Future<List<Product>> getProducts(int categoryId) async {
    final json = await api.fetchProducts(categoryId);
    if (json['status'] == true) {
      return ProductResponse.fromJson(json).data;
    }
    throw ApiException(json['message'] ?? 'Product fetch failed');
  }

  Future<List<String>> getBanners() => api.fetchBanners();
}
