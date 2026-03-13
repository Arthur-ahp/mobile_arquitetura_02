import 'package:flutter/foundation.dart';
import 'package:product_app/domain/entities/product.dart';
import 'package:product_app/domain/repositories/product_repository.dart';
import 'product_state.dart';

class ProductViewModel {
  final ProductRepository repository;

  final ValueNotifier<ProductState> state =
      ValueNotifier(ProductState());

  ProductViewModel(this.repository);

  Future<void> loadProducts() async {
    state.value = state.value.copyWith(isLoading: true);

    try {
      final products = await repository.getProducts();

      state.value = state.value.copyWith(
        isLoading: false,
        products: products,
      );
    } catch (e) {
      state.value = state.value.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  void toggleFavorite(Product product) {
    product.favorite = !product.favorite;

    state.value = state.value.copyWith(
      products: List.from(state.value.products),
    );
  }
}