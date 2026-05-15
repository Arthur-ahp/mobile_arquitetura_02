import 'package:product_app/core/errors/failure.dart';
import 'package:product_app/data/datasources/auth_remote_datasource.dart';
import 'package:product_app/domain/entities/auth_user.dart';
import 'package:product_app/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDatasource remote;

  AuthRepositoryImpl(this.remote);

  @override
  Future<AuthUser> login({
    required String username,
    required String password,
  }) async {
    try {
      final model = await remote.login(username: username, password: password);
      return model.toEntity();
    } catch (e) {
      throw Failure('Usuario ou senha invalidos');
    }
  }

  @override
  Future<AuthUser> getCurrentUser(String accessToken) async {
    try {
      final model = await remote.getCurrentUser(accessToken);
      return model.toEntity();
    } catch (e) {
      throw Failure('Token invalido ou expirado');
    }
  }
}
