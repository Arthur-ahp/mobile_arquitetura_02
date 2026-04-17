import 'package:product_app/domain/entities/product.dart';

class ProductState {
  final bool isLoading;
  final List<Product> products;
  final String? error;
  final String? filterCategory;

  const ProductState({
    this.isLoading = false,
    this.products = const [],
    this.error,
    this.filterCategory,
  });

  List<Product> get filteredProducts {
    if (filterCategory == null || filterCategory!.isEmpty) return products;
    return products.where((p) => p.category == filterCategory).toList();
  }

  ProductState copyWith({
    bool? isLoading,
    List<Product>? products,
    String? error,
    String? filterCategory,
    bool clearFilter = false,
    bool clearError = false,
  }) {
    return ProductState(
      isLoading: isLoading ?? this.isLoading,
      products: products ?? this.products,
      error: clearError ? null : (error ?? this.error),
      filterCategory: clearFilter ? null : (filterCategory ?? this.filterCategory),
    );
  }
}
