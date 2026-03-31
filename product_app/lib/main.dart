import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:product_app/data/datasources/product_cache_datasource.dart';
import 'package:product_app/data/datasources/product_remote_datasource.dart';
import 'package:product_app/data/repositories/product_repository_impl.dart';
import 'package:product_app/presentation/pages/home_page.dart';
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
      home: HomePage(viewModel: viewModel),
    );
  }
}
