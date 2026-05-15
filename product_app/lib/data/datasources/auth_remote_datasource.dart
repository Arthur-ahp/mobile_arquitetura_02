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
    final response = await client.post(
      '$_baseUrl/login',
      data: {'username': username, 'password': password, 'expiresInMins': 30},
    );
    return AuthUserModel.fromJson(response.data);
  }

  Future<AuthUserModel> getCurrentUser(String accessToken) async {
    final response = await client.get(
      '$_baseUrl/me',
      options: Options(headers: {'Authorization': 'Bearer $accessToken'}),
    );
    return AuthUserModel.fromJson(response.data);
  }
}
