import 'dart:convert';
import 'package:apnamall_ecommerce_app/core/network/api_client.dart';
import 'package:apnamall_ecommerce_app/core/network/api_endpoint.dart';

class ProductApiClient {
  final ApiClient apiClient;
  ProductApiClient(this.apiClient);

  // bearer token automatic via ApiClient options
  Future<Map<String, dynamic>> fetchCategories() async {
    final res = await apiClient.get(ApiEndpoint.categories);

    // Handle if res.data is a raw String
    if (res.data is String) {
      return jsonDecode(res.data);
    }

    return res.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> fetchProducts(int categoryId) async {
    final res = await apiClient.post(
      ApiEndpoint.products,
      body: {'category_id': categoryId},
    );

    // Just in case this too returns raw string
    if (res.data is String) {
      return jsonDecode(res.data);
    }

    return res.data as Map<String, dynamic>;
  }

  // dummy banners (could be future API)
 Future<List<String>> fetchBanners() async => [
  'https://previews.123rf.com/images/ikopylov/ikopylov1903/ikopylov190300005/124748046-big-beauty-sale-cosmetics-banner-for-shopping-season-makeup-accessories-equipment-beauty-facial.jpg',
  'https://www.shutterstock.com/image-vector/special-offer-banner-vector-template-260nw-2474802375.jpg',
  'https://d1csarkz8obe9u.cloudfront.net/posterpreviews/shoes-best-offer-sale-design-template-f130d383d53aa7e786074dfd1bd3f433_screen.jpg?ts=1678348284',
  'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRNUkcGq4VekWtlPKCBWq71yYg_BBdYmfSbHw&s',
];
}
