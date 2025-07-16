import 'package:apnamall_ecommerce_app/features/products/data/model/category_model.dart';
import 'package:apnamall_ecommerce_app/features/products/data/model/product_model.dart';

abstract class ProductState {}

class ProductInitial extends ProductState {}

class ProductLoading extends ProductState {}

class ProductLoaded extends ProductState {
  final List<Category> categories;
  final List<Product> products;
  final List<String> banners;
  final int selectedCategoryId;
  final bool isProductLoading;

  ProductLoaded({
    required this.categories,
    required this.products,
    required this.banners,
    required this.selectedCategoryId,
    this.isProductLoading = false,
  });

  ProductLoaded copyWith({
    List<Category>? categories,
    List<Product>? products,
    List<String>? banners,
    int? selectedCategoryId,
    bool? isProductLoading,
  }) {
    return ProductLoaded(
      categories: categories ?? this.categories,
      products: products ?? this.products,
      banners: banners ?? this.banners,
      selectedCategoryId: selectedCategoryId ?? this.selectedCategoryId,
      isProductLoading: isProductLoading ?? this.isProductLoading,
    );
  }
}


class ProductFailure extends ProductState {
  final String message;
  ProductFailure(this.message);
}
