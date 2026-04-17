import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:product_app/data/datasources/product_cache_datasource.dart';
import 'package:product_app/data/datasources/product_remote_datasource.dart';
import 'package:product_app/data/repositories/product_repository_impl.dart';
import 'package:product_app/domain/entities/product.dart';
import 'package:product_app/presentation/pages/home_page.dart';
import 'package:product_app/presentation/pages/product_detail_page.dart';
import 'package:product_app/presentation/pages/product_form_page.dart';
import 'package:product_app/presentation/pages/product_page.dart';
import 'package:product_app/presentation/viewmodels/product_viewmodel.dart';

void main() {
  final client = Dio();
  final remote = ProductRemoteDatasource(client);
  final cache = ProductCacheDatasource();
  final repository = ProductRepositoryImpl(remote, cache);
  final viewModel = ProductViewModel(repository);

  viewModel.loadProducts();

  runApp(MyApp(viewModel));
}

class MyApp extends StatelessWidget {
  final ProductViewModel viewModel;

  const MyApp(this.viewModel, {super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gerenciador de Produtos',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
      ),
      initialRoute: '/',
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case '/':
            return MaterialPageRoute(
              builder: (_) => HomePage(viewModel: viewModel),
            );
          case '/products':
            return MaterialPageRoute(
              builder: (_) => ProductPage(viewModel: viewModel),
            );
          case '/product/detail':
            final product = settings.arguments as Product;
            return MaterialPageRoute(
              builder: (_) => ProductDetailPage(
                product: product,
                viewModel: viewModel,
              ),
            );
          case '/product/form':
            final args = settings.arguments as Map<String, dynamic>?;
            return MaterialPageRoute(
              builder: (_) => ProductFormPage(
                viewModel: viewModel,
                product: args?['product'] as Product?,
              ),
            );
          default:
            return MaterialPageRoute(
              builder: (_) => HomePage(viewModel: viewModel),
            );
        }
      },
    );
  }
}
