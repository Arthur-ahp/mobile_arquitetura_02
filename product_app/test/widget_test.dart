import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:product_app/domain/entities/auth_user.dart';
import 'package:product_app/domain/repositories/auth_repository.dart';
import 'package:product_app/presentation/pages/login_page.dart';
import 'package:product_app/presentation/viewmodels/auth_viewmodel.dart';

class FakeAuthRepository implements AuthRepository {
  @override
  Future<AuthUser> login({
    required String username,
    required String password,
  }) async {
    return AuthUser(
      id: 1,
      username: username,
      email: 'emilys@example.com',
      firstName: 'Emily',
      lastName: 'Smith',
      image: '',
      accessToken: 'access-token',
      refreshToken: 'refresh-token',
    );
  }

  @override
  Future<AuthUser> getCurrentUser(String accessToken) async {
    return AuthUser(
      id: 1,
      username: 'emilys',
      email: 'emilys@example.com',
      firstName: 'Emily',
      lastName: 'Smith',
      image: '',
      accessToken: accessToken,
      refreshToken: 'refresh-token',
    );
  }
}

void main() {
  testWidgets('exibe tela de login', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: LoginPage(authViewModel: AuthViewModel(FakeAuthRepository())),
      ),
    );

    expect(find.text('Acesso ao Sistema'), findsOneWidget);
    expect(find.text('Entrar'), findsOneWidget);
    expect(find.byType(TextFormField), findsNWidgets(2));
  });
}
