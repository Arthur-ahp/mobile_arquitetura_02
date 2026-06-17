import 'package:dio/dio.dart';
import 'package:product_app/data/models/auth_user_model.dart';

class AuthRemoteDatasource {
  final Dio client;
  static const String _baseUrl = 'https://dummyjson.com/auth';

  AuthRemoteDatasource(this.client);

  Future<AuthUserModel> login({
    required String username,
    required String password,
  }) async {
    try {
      final response = await client.post(
        '$_baseUrl/login',
        data: {'username': username, 'password': password, 'expiresInMins': 30},
      );
      return AuthUserModel.fromJson(response.data);
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        throw Exception('Tempo limite excedido ao realizar login');
      }
      throw Exception('Usuario ou senha invalidos');
    }
  }

  Future<AuthUserModel> getCurrentUser(String accessToken) async {
    try {
      final response = await client.get(
        '$_baseUrl/me',
        options: Options(headers: {'Authorization': 'Bearer $accessToken'}),
      );
      return AuthUserModel.fromJson(response.data);
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        throw Exception('Tempo limite excedido ao validar sessao');
      }
      throw Exception('Token invalido ou expirado');
    }
  }
}
