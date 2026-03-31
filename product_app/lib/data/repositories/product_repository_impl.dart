import 'package:product_app/core/errors/failure.dart';
import 'package:product_app/data/datasources/product_cache_datasource.dart';
import 'package:product_app/data/datasources/product_remote_datasource.dart';
import 'package:product_app/data/models/product_model.dart';
import 'package:product_app/domain/entities/product.dart';
import 'package:product_app/domain/repositories/product_repository.dart';

class ProductRepositoryImpl implements ProductRepository {
  final ProductRemoteDatasource remote;
  final ProductCacheDatasource cache;

  ProductRepositoryImpl(this.remote, this.cache);

  @override
  Future<List<Product>> getProducts() async {
    try {
      final models = await remote.getProducts();
      cache.save(models);
      return models.map((m) => m.toEntity()).toList();
    } catch (e) {
      final cached = cache.get();
      if (cached != null) {
        return cached.map((m) => m.toEntity()).toList();
      }
      throw Failure('Não foi possível carregar os produtos!');
    }
  }

  @override
  Future<Product> createProduct(Product product) async {
    try {
      final model = ProductModel.fromEntity(product);
      final created = await remote.createProduct(model);
      // A FakeStore retorna o objeto com id simulado; adicionamos ao cache
      final withId = ProductModel(
        id: created.id ?? DateTime.now().millisecondsSinceEpoch,
        title: product.title,
        price: product.price,
        image: product.image,
        description: product.description,
        category: product.category,
      );
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
      await remote.deleteProduct(id);
      cache.remove(id);
    } catch (e) {
      throw Failure('Erro ao excluir produto: $e');
    }
  }
}
