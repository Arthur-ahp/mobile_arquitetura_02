import 'package:flutter/material.dart';
import 'package:product_app/domain/entities/product.dart';
import 'package:product_app/presentation/viewmodels/product_viewmodel.dart';

class ProductDetailPage extends StatefulWidget {
  final int productId;
  final ProductViewModel viewModel;

  const ProductDetailPage({
    super.key,
    required this.productId,
    required this.viewModel,
  });

  @override
  State<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  late final Future<Product?> _productFuture;

  @override
  void initState() {
    super.initState();
    _productFuture = widget.viewModel.getProductById(widget.productId);
  }

  Future<void> _confirmDelete(BuildContext context, Product product) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Confirmar exclusao'),
        content: Text('Deseja excluir "${product.title}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Excluir'),
          ),
        ],
      ),
    );

    if (confirmed == true && context.mounted && product.id != null) {
      final ok = await widget.viewModel.deleteProduct(product.id!);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(ok ? 'Produto excluido!' : 'Erro ao excluir.'),
          ),
        );
        if (ok) Navigator.pop(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Product?>(
      future: _productFuture,
      builder: (context, snapshot) {
        final product = snapshot.data;

        return Scaffold(
          appBar: AppBar(
            title: const Text('Detalhes do Produto'),
            centerTitle: true,
            actions: [
              if (product?.id != null)
                IconButton(
                  icon: const Icon(Icons.delete_outline, color: Colors.red),
                  tooltip: 'Excluir',
                  onPressed: () => _confirmDelete(context, product!),
                ),
            ],
          ),
          floatingActionButton: product?.id != null
              ? FloatingActionButton(
                  onPressed: () => Navigator.pushNamed(
                    context,
                    '/product/form',
                    arguments: {'product': product},
                  ),
                  tooltip: 'Editar',
                  child: const Icon(Icons.edit_outlined),
                )
              : null,
          body: _buildBody(context, snapshot),
        );
      },
    );
  }

  Widget _buildBody(BuildContext context, AsyncSnapshot<Product?> snapshot) {
    if (snapshot.connectionState == ConnectionState.waiting) {
      return const Center(child: CircularProgressIndicator());
    }

    if (snapshot.hasError || snapshot.data == null) {
      return const Center(child: Text('Produto nao encontrado.'));
    }

    final product = snapshot.data!;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.network(
                product.thumbnail,
                height: 220,
                fit: BoxFit.contain,
                errorBuilder: (_, __, ___) => Container(
                  height: 220,
                  color: Colors.grey[200],
                  child: const Icon(
                    Icons.image_not_supported,
                    size: 60,
                    color: Colors.grey,
                  ),
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
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
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
          const SizedBox(height: 12),
          Row(
            children: [
              const Icon(Icons.star, size: 18, color: Colors.amber),
              const SizedBox(width: 4),
              Text(product.rating.toStringAsFixed(1)),
              const SizedBox(width: 16),
              const Icon(Icons.inventory_2_outlined, size: 18),
              const SizedBox(width: 4),
              Text('Estoque: ${product.stock}'),
            ],
          ),
          const SizedBox(height: 20),
          const Divider(),
          const SizedBox(height: 12),
          Text(
            'Descricao',
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
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
                  product.favorite ? 'Favoritado' : 'Nao favoritado',
                  style: TextStyle(color: Colors.grey[600], fontSize: 13),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
