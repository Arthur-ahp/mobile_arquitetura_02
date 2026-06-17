import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:product_app/data/datasources/auth_remote_datasource.dart';
import 'package:product_app/data/datasources/product_cache_datasource.dart';
import 'package:product_app/data/datasources/product_remote_datasource.dart';
import 'package:product_app/data/repositories/auth_repository_impl.dart';
import 'package:product_app/data/repositories/product_repository_impl.dart';
import 'package:product_app/core/session/session_controller.dart';
import 'package:product_app/presentation/pages/login_page.dart';
import 'package:product_app/presentation/pages/product_detail_page.dart';
import 'package:product_app/presentation/pages/product_form_page.dart';
import 'package:product_app/presentation/pages/product_page.dart';
import 'package:product_app/presentation/viewmodels/auth_viewmodel.dart';
import 'package:product_app/presentation/viewmodels/product_viewmodel.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SessionController.instance.restoreSession();
  runApp(
    MyApp(
      initialRoute: SessionController.instance.isLoggedIn
          ? '/products'
          : '/login',
    ),
  );
}

class MyApp extends StatelessWidget {
  final String initialRoute;

  const MyApp({super.key, required this.initialRoute});

  @override
  Widget build(BuildContext context) {
    final dio = Dio(
      BaseOptions(
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
      ),
    );

    final authViewModel = AuthViewModel(
      AuthRepositoryImpl(AuthRemoteDatasource(dio)),
    );

    final productViewModel = ProductViewModel(
      ProductRepositoryImpl(
        ProductRemoteDatasource(dio),
        ProductCacheDatasource(),
      ),
    );

    return MaterialApp(
      title: 'Gerenciador de Produtos',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
      ),
      initialRoute: initialRoute,
      routes: {
        '/login': (_) => LoginPage(authViewModel: authViewModel),
        '/products': (_) => ProductPage(
          viewModel: productViewModel,
          authViewModel: authViewModel,
        ),
      },
      onGenerateRoute: (settings) {
        if (settings.name == '/product/detail') {
          final id = settings.arguments as int;
          return MaterialPageRoute(
            builder: (_) =>
                ProductDetailPage(productId: id, viewModel: productViewModel),
          );
        }

        if (settings.name == '/product/form') {
          final args = settings.arguments as Map<String, dynamic>?;
          return MaterialPageRoute(
            builder: (_) => ProductFormPage(
              viewModel: productViewModel,
              product: args?['product'],
            ),
          );
        }

        return null;
      },
    );
  }
}
