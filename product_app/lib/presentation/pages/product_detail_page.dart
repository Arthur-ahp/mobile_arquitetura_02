import 'package:flutter/material.dart';
import 'package:product_app/domain/entities/product.dart';

class ProductDetailPage extends StatelessWidget {
  final Product product;

  const ProductDetailPage({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(product.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Image.network(product.image, height: 200),

            const SizedBox(height: 20),

            Text(
              product.title,
              style: const TextStyle(fontSize: 20),
            ),

            const SizedBox(height: 10),

            Text("\$${product.price}"),

            const SizedBox(height: 20),

            Text(product.description ?? "Sem descrição"),
          ],
        ),
      ),
    );
  }
}