import 'package:product_app/data/models/product_model.dart';

class ProductCacheDatasource {
  List<ProductModel>? _cache;

  void save(List<ProductModel> products) {
    _cache = List.from(products);
  }

  List<ProductModel>? get() => _cache;

  void addOrUpdate(ProductModel product) {
    if (_cache == null) return;
    final index = _cache!.indexWhere((p) => p.id == product.id);
    if (index >= 0) {
      _cache![index] = product;
    } else {
      _cache!.add(product);
    }
  }

  void remove(int id) {
    _cache?.removeWhere((p) => p.id == id);
  }

  void clear() {
    _cache = null;
  }
}
