import 'package:flutter/material.dart';
import 'package:product_app/domain/entities/product.dart';

class ProductDetailPage extends StatelessWidget {
  final Product product;

  const ProductDetailPage({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalhes do Produto'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.network(
                  product.image,
                  height: 220,
                  fit: BoxFit.contain,
                  errorBuilder: (_, __, ___) => Container(
                    height: 220,
                    color: Colors.grey[200],
                    child: const Icon(Icons.image_not_supported,
                        size: 60, color: Colors.grey),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.secondaryContainer,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                product.category.toUpperCase(),
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.secondary,
                ),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              product.title,
              style: Theme.of(context)
                  .textTheme
                  .titleLarge
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Text(
              'R\$ ${product.price.toStringAsFixed(2)}',
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            const SizedBox(height: 20),
            const Divider(),
            const SizedBox(height: 12),
            Text(
              'Descrição',
              style: Theme.of(context)
                  .textTheme
                  .titleMedium
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              product.description,
              style: const TextStyle(fontSize: 15, height: 1.6),
            ),
            if (product.id != null) ...[
              const SizedBox(height: 20),
              const Divider(),
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(Icons.tag, size: 16, color: Colors.grey),
                  const SizedBox(width: 4),
                  Text(
                    'ID: ${product.id}',
                    style: TextStyle(color: Colors.grey[600], fontSize: 13),
                  ),
                  const SizedBox(width: 16),
                  Icon(
                    product.favorite ? Icons.star : Icons.star_border,
                    size: 16,
                    color: product.favorite ? Colors.amber : Colors.grey,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    product.favorite ? 'Favoritado' : 'Não favoritado',
                    style: TextStyle(color: Colors.grey[600], fontSize: 13),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}
