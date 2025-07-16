import 'package:apnamall_ecommerce_app/core/errors/api_exceptions.dart';
import 'package:apnamall_ecommerce_app/features/products/data/model/product_model.dart';
import 'package:apnamall_ecommerce_app/features/products/data/product_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'product_event.dart';
import 'product_state.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final ProductRepository repo;

  ProductBloc({required this.repo}) : super(ProductInitial()) {
    on<LoadHomeData>(_onLoad);
    on<ChangeCategory>(_onChangeCategory);
    on<RefreshHome>(_onRefresh);
  }

  Future<void> _onLoad(LoadHomeData event, Emitter<ProductState> emit) async {
    emit(ProductLoading());
    try {
      print('Fetching categories...');
      final categories = await repo.getCategories();
      print('Categories: $categories');
      print('Categories Type: ${categories.runtimeType}');

      print('Fetching banners...');
      final banners = await repo.getBanners();
      print('Banners: $banners');
      print('Banners Type: ${banners.runtimeType}');

      final firstCatId = categories.isNotEmpty ? categories.first.id : 0;
      print('First category ID: $firstCatId');
      List<Product> products = [];
      if (firstCatId != 0) {
        print('Fetching products for category $firstCatId...');
        products = await repo.getProducts(firstCatId);
        print('Products: $products');
        print('Products Type: ${products.runtimeType}');
      }
      emit(
        ProductLoaded(
          categories: categories,
          products: products,
          banners: banners,
          selectedCategoryId: firstCatId,
        ),
      );
    } catch (e) {
    if (e is ApiException) {
      print("❌ API ERROR: ${e.message} | code: ${e.statusCode}");
      print("Type: ${e.runtimeType}");
    } else {
      print("❌ Unknown Error: $e");
    }
    emit(ProductFailure(e.toString()));
    }
  }

  Future<void> _onChangeCategory(
    ChangeCategory event,
    Emitter<ProductState> emit,
  ) async {
    if (state is! ProductLoaded) return;
    final current = state as ProductLoaded;

    // Show only product loader
    emit(current.copyWith(isProductLoading: true));

    try {
      print('Changing to category: ${event.categoryId}');
      final products = await repo.getProducts(event.categoryId);
      print('Fetched products: $products');
      print('Type: ${products.runtimeType}');

      emit(
        current.copyWith(
          products: products,
          selectedCategoryId: event.categoryId,
          isProductLoading: false,
        ),
      );
    } catch (e, st) {
      print('❌ Error in _onChangeCategory: $e');
      print('Stacktrace:\n$st');
      emit(ProductFailure(e.toString()));
    }
  }

  Future<void> _onRefresh(RefreshHome event, Emitter<ProductState> emit) async {
    add(LoadHomeData());
  }
}
