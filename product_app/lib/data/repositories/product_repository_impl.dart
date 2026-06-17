import 'dart:math';
import 'package:product_app/core/errors/failure.dart';
import 'package:product_app/data/datasources/product_cache_datasource.dart';
import 'package:product_app/data/datasources/product_remote_datasource.dart';
import 'package:product_app/data/models/product_model.dart';
import 'package:product_app/domain/entities/product.dart';
import 'package:product_app/domain/repositories/product_repository.dart';

class ProductRepositoryImpl implements ProductRepository {
  final ProductRemoteDatasource remote;
  final ProductCacheDatasource cache;
  final Map<int, ProductModel> _localProducts = {};

  ProductRepositoryImpl(this.remote, this.cache);

  int _generateId() {
    final rand = Random();
    return DateTime.now().millisecondsSinceEpoch + rand.nextInt(99999);
  }

  @override
  Future<List<Product>> getProducts() async {
    try {
      final models = await remote.getProducts();
      final merged = _mergeLocalProducts(models);
      cache.save(merged);
      return merged.map((m) => m.toEntity()).toList();
    } catch (e) {
      final cached = cache.get();
      if (cached != null) {
        return cached.map((m) => m.toEntity()).toList();
      }
      throw Failure('Não foi possível carregar os produtos!');
    }
  }

  @override
  Future<Product> getProductById(int id) async {
    try {
      final model = await remote.getProductById(id);
      cache.addOrUpdate(model);
      return model.toEntity();
    } catch (e) {
      final cached = cache.get();
      if (cached != null) {
        for (final product in cached) {
          if (product.id == id) return product.toEntity();
        }
      }
      throw Failure('Erro ao carregar produto: $e');
    }
  }

  @override
  Future<Product> createProduct(Product product) async {
    try {
      final model = ProductModel.fromEntity(product);
      final created = await remote.createProduct(model);
      final withId = ProductModel(
        id: (created.id != null && created.id! > 0)
            ? created.id
            : _generateId(),
        title: product.title,
        price: product.price,
        rating: product.rating,
        stock: product.stock,
        thumbnail: product.thumbnail,
        description: product.description,
        category: product.category,
        favorite: product.favorite,
      );
      if (withId.id != null) {
        _localProducts[withId.id!] = withId;
      }
      cache.addOrUpdate(withId);
      return withId.toEntity();
    } catch (e) {
      throw Failure('Erro ao criar produto: $e');
    }
  }

  @override
  Future<Product> updateProduct(Product product) async {
    try {
      final model = ProductModel.fromEntity(product);
      if (product.id != null && _localProducts.containsKey(product.id)) {
        _localProducts[product.id!] = model;
        cache.addOrUpdate(model);
        return model.toEntity();
      }

      final updated = await remote.updateProduct(model);
      cache.addOrUpdate(updated);
      return updated.toEntity();
    } catch (e) {
      throw Failure('Erro ao atualizar produto: $e');
    }
  }

  @override
  Future<void> deleteProduct(int id) async {
    try {
      if (_localProducts.remove(id) != null) {
        cache.remove(id);
        return;
      }

      await remote.deleteProduct(id);
      cache.remove(id);
    } catch (e) {
      throw Failure('Erro ao excluir produto: $e');
    }
  }

  List<ProductModel> _mergeLocalProducts(List<ProductModel> remoteProducts) {
    final merged = List<ProductModel>.from(remoteProducts);
    for (final localProduct in _localProducts.values) {
      final index = merged.indexWhere((p) => p.id == localProduct.id);
      if (index >= 0) {
        merged[index] = localProduct;
      } else {
        merged.add(localProduct);
      }
    }
    return merged;
  }
}
