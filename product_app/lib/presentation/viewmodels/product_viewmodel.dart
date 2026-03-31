import 'package:flutter/foundation.dart';
import 'package:product_app/domain/entities/product.dart';
import 'package:product_app/domain/repositories/product_repository.dart';
import 'product_state.dart';

class ProductViewModel {
  final ProductRepository repository;

  final ValueNotifier<ProductState> state = ValueNotifier(ProductState());

  ProductViewModel(this.repository);

  Future<void> loadProducts() async {
    state.value = state.value.copyWith(isLoading: true, error: null);
    try {
      final products = await repository.getProducts();
      state.value = state.value.copyWith(isLoading: false, products: products);
    } catch (e) {
      state.value = state.value.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<bool> createProduct(Product product) async {
    try {
      final created = await repository.createProduct(product);
      final updated = List<Product>.from(state.value.products)..add(created);
      state.value = state.value.copyWith(products: updated);
      return true;
    } catch (e) {
      state.value = state.value.copyWith(error: e.toString());
      return false;
    }
  }

  Future<bool> updateProduct(Product product) async {
    try {
      final updated = await repository.updateProduct(product);
      final list = state.value.products.map((p) {
        return p.id == updated.id ? updated : p;
      }).toList();
      state.value = state.value.copyWith(products: list);
      return true;
    } catch (e) {
      state.value = state.value.copyWith(error: e.toString());
      return false;
    }
  }

  Future<bool> deleteProduct(int id) async {
    try {
      await repository.deleteProduct(id);
      final list = state.value.products.where((p) => p.id != id).toList();
      state.value = state.value.copyWith(products: list);
      return true;
    } catch (e) {
      state.value = state.value.copyWith(error: e.toString());
      return false;
    }
  }

  void toggleFavorite(Product product) {
    product.favorite = !product.favorite;
    state.value = state.value.copyWith(products: List.from(state.value.products));
  }
}
