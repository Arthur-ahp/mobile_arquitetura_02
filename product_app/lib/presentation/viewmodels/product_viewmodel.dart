import 'package:flutter/foundation.dart';
import 'package:product_app/domain/entities/product.dart';
import 'package:product_app/domain/repositories/product_repository.dart';
import 'product_state.dart';

class ProductViewModel {
  final ProductRepository repository;

  final ValueNotifier<ProductState> state = ValueNotifier(ProductState());

  ProductViewModel(this.repository);

  Future<void> loadProducts() async {
    state.value = state.value.copyWith(isLoading: true, clearError: true);
    try {
      final products = await repository.getProducts();
      final favorites = {
        for (final product in state.value.products)
          if (product.id != null && product.favorite) product.id,
      };
      final merged = products.map((product) {
        return product.copyWith(favorite: favorites.contains(product.id));
      }).toList();
      state.value = state.value.copyWith(isLoading: false, products: merged);
    } catch (e) {
      state.value = state.value.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<Product?> getProductById(int id) async {
    try {
      final product = await repository.getProductById(id);
      final products = List<Product>.from(state.value.products);
      final index = products.indexWhere((p) => p.id == product.id);
      final favorite = index >= 0 ? products[index].favorite : product.favorite;
      final updatedProduct = product.copyWith(favorite: favorite);
      if (index >= 0) {
        products[index] = updatedProduct;
      } else {
        products.add(updatedProduct);
      }
      state.value = state.value.copyWith(products: products, clearError: true);
      return updatedProduct;
    } catch (e) {
      state.value = state.value.copyWith(error: e.toString());
      return null;
    }
  }

  Future<bool> createProduct(Product product) async {
    state.value = state.value.copyWith(isLoading: true, clearError: true);
    try {
      final created = await repository.createProduct(product);
      final updated = List<Product>.from(state.value.products)..add(created);
      state.value = state.value.copyWith(isLoading: false, products: updated);
      return true;
    } catch (e) {
      state.value = state.value.copyWith(isLoading: false, error: e.toString());
      return false;
    }
  }

  Future<bool> updateProduct(Product product) async {
    state.value = state.value.copyWith(isLoading: true, clearError: true);
    try {
      final updated = await repository.updateProduct(product);
      final updatedWithFavorite = updated.copyWith(favorite: product.favorite);
      final list = state.value.products.map((p) {
        return p.id == updatedWithFavorite.id ? updatedWithFavorite : p;
      }).toList();
      state.value = state.value.copyWith(isLoading: false, products: list);
      return true;
    } catch (e) {
      state.value = state.value.copyWith(isLoading: false, error: e.toString());
      return false;
    }
  }

  Future<bool> deleteProduct(int id) async {
    state.value = state.value.copyWith(isLoading: true, clearError: true);
    try {
      await repository.deleteProduct(id);
      final list = state.value.products.where((p) => p.id != id).toList();
      state.value = state.value.copyWith(isLoading: false, products: list);
      return true;
    } catch (e) {
      state.value = state.value.copyWith(isLoading: false, error: e.toString());
      return false;
    }
  }

  void toggleFavorite(Product product) {
    final updated = state.value.products.map((p) {
      return p.id == product.id ? p.copyWith(favorite: !p.favorite) : p;
    }).toList();
    state.value = state.value.copyWith(products: updated);
  }

  void filterByCategory(String? category) {
    state.value = state.value.copyWith(
      filterCategory: category,
      clearFilter: category == null || category.isEmpty,
    );
  }
}
