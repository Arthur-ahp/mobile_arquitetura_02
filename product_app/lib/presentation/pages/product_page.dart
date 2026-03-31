import 'package:flutter/material.dart';
import 'package:product_app/presentation/viewmodels/product_state.dart';
import 'package:product_app/presentation/viewmodels/product_viewmodel.dart';
import 'package:product_app/presentation/widgets/product_card.dart';
import 'product_detail_page.dart';
import 'product_form_page.dart';

class ProductPage extends StatelessWidget {
  final ProductViewModel viewModel;

  const ProductPage({super.key, required this.viewModel});

  Future<void> _confirmDelete(BuildContext context, int id, String title) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Confirmar exclusão'),
        content: Text('Deseja excluir "$title"?'),
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

    if (confirmed == true) {
      final ok = await viewModel.deleteProduct(id);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(ok ? 'Produto excluído!' : 'Erro ao excluir.')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Produtos'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Atualizar',
            onPressed: viewModel.loadProducts,
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => ProductFormPage(viewModel: viewModel),
            ),
          );
        },
        icon: const Icon(Icons.add),
        label: const Text('Novo Produto'),
      ),
      body: ValueListenableBuilder<ProductState>(
        valueListenable: viewModel.state,
        builder: (context, state, _) {
          if (state.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.error != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 60, color: Colors.red),
                  const SizedBox(height: 12),
                  Text(state.error!, textAlign: TextAlign.center),
                  const SizedBox(height: 16),
                  FilledButton(
                    onPressed: viewModel.loadProducts,
                    child: const Text('Tentar novamente'),
                  ),
                ],
              ),
            );
          }

          if (state.products.isEmpty) {
            return const Center(child: Text('Nenhum produto encontrado.'));
          }

          return ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 12),
            itemCount: state.products.length,
            itemBuilder: (context, index) {
              final product = state.products[index];
              return ProductCard(
                product: product,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ProductDetailPage(product: product),
                    ),
                  );
                },
                onEdit: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ProductFormPage(
                        viewModel: viewModel,
                        product: product,
                      ),
                    ),
                  );
                },
                onDelete: () {
                  if (product.id != null) {
                    _confirmDelete(context, product.id!, product.title);
                  }
                },
                onToggleFavorite: () => viewModel.toggleFavorite(product),
              );
            },
          );
        },
      ),
    );
  }
}
