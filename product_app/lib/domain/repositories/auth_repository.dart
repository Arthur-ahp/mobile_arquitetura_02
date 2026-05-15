import 'package:product_app/domain/entities/auth_user.dart';

abstract class AuthRepository {
  Future<AuthUser> login({required String username, required String password});
  Future<AuthUser> getCurrentUser(String accessToken);
}
