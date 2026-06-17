import 'package:dio/dio.dart';
import 'package:product_app/data/models/product_model.dart';

class ProductRemoteDatasource {
  final Dio client;
  static const String _baseUrl = 'https://dummyjson.com/products';

  ProductRemoteDatasource(this.client);

  Future<List<ProductModel>> getProducts() async {
    try {
      final response = await client.get(_baseUrl);
      final List<dynamic> data = response.data['products'];
      return data.map((json) => ProductModel.fromJson(json)).toList();
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        throw Exception('Tempo limite excedido ao carregar produtos');
      }
      throw Exception('Erro ao carregar produtos');
    }
  }

  Future<ProductModel> getProductById(int id) async {
    try {
      final response = await client.get('$_baseUrl/$id');
      return ProductModel.fromJson(response.data);
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        throw Exception('Tempo limite excedido ao carregar produto');
      }
      throw Exception('Erro ao carregar produto');
    }
  }

  Future<ProductModel> createProduct(ProductModel product) async {
    try {
      final response = await client.post(
        '$_baseUrl/add',
        data: product.toJson(),
      );
      return ProductModel.fromJson(response.data);
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        throw Exception('Tempo limite excedido ao criar produto');
      }
      throw Exception('Erro ao criar produto');
    }
  }

  Future<ProductModel> updateProduct(ProductModel product) async {
    try {
      final response = await client.put(
        '$_baseUrl/${product.id}',
        data: product.toJson(),
      );
      return ProductModel.fromJson(response.data);
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        throw Exception('Tempo limite excedido ao atualizar produto');
      }
      throw Exception('Erro ao atualizar produto');
    }
  }

  Future<void> deleteProduct(int id) async {
    try {
      await client.delete('$_baseUrl/$id');
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        throw Exception('Tempo limite excedido ao excluir produto');
      }
      throw Exception('Erro ao excluir produto');
    }
  }
}
