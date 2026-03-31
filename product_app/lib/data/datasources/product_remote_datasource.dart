import 'package:dio/dio.dart';
import 'package:product_app/data/models/product_model.dart';

class ProductRemoteDatasource {
  final Dio client;
  static const String _baseUrl = 'https://fakestoreapi.com/products';

  ProductRemoteDatasource(this.client);

  Future<List<ProductModel>> getProducts() async {
    final response = await client.get(_baseUrl);
    final List<dynamic> data = response.data;
    return data.map((json) => ProductModel.fromJson(json)).toList();
  }

  Future<ProductModel> createProduct(ProductModel product) async {
    final response = await client.post(
      _baseUrl,
      data: product.toJson(),
    );
    return ProductModel.fromJson(response.data);
  }

  Future<ProductModel> updateProduct(ProductModel product) async {
    final response = await client.put(
      '$_baseUrl/${product.id}',
      data: product.toJson(),
    );
    return ProductModel.fromJson(response.data);
  }

  Future<void> deleteProduct(int id) async {
    await client.delete('$_baseUrl/$id');
  }
}
