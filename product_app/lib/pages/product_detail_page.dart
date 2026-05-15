import 'package:flutter/material.dart';
import 'package:product_app/models/product.dart';
import 'package:product_app/services/product_service.dart';

class ProductDetailPage extends StatelessWidget {
  final int productId;

  ProductDetailPage({super.key, required this.productId});

  final ProductService _service = ProductService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Detalhes do Produto')),
      body: FutureBuilder<Product>(
        future: _service.getProductById(productId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Erro: ${snapshot.error}'));
          }

          if (!snapshot.hasData) {
            return const Center(child: Text('Produto nao encontrado'));
          }

          final product = snapshot.data!;

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Image.network(
                product.thumbnail,
                height: 180,
                errorBuilder: (_, __, ___) =>
                    const Icon(Icons.image_not_supported, size: 80),
              ),
              const SizedBox(height: 16),
              Text(
                product.title,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text('Categoria: ${product.category}'),
              Text('Preco: R\$ ${product.price.toStringAsFixed(2)}'),
              Text('Avaliacao: ${product.rating}'),
              Text('Estoque: ${product.stock}'),
              const SizedBox(height: 16),
              Text(product.description),
            ],
          );
        },
      ),
    );
  }
}
