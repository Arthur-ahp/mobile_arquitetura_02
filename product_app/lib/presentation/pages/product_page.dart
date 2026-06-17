import 'package:flutter/material.dart';
import 'package:product_app/core/session/session_controller.dart';
import 'package:product_app/presentation/viewmodels/auth_viewmodel.dart';
import 'package:product_app/presentation/viewmodels/product_state.dart';
import 'package:product_app/presentation/viewmodels/product_viewmodel.dart';
import 'package:product_app/presentation/widgets/product_card.dart';

class ProductPage extends StatefulWidget {
  final ProductViewModel viewModel;
  final AuthViewModel authViewModel;

  const ProductPage({
    super.key,
    required this.viewModel,
    required this.authViewModel,
  });

  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  @override
  void initState() {
    super.initState();
    if (SessionController.instance.isLoggedIn) {
      widget.viewModel.loadProducts();
    } else {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) Navigator.pushReplacementNamed(context, '/login');
      });
    }
  }

  Future<void> _confirmDelete(
    BuildContext context,
    int id,
    String title,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Confirmar exclusao'),
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
      final ok = await widget.viewModel.deleteProduct(id);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(ok ? 'Produto excluido!' : 'Erro ao excluir.'),
          ),
        );
      }
    }
  }

  Future<void> _logout() async {
    await widget.authViewModel.logout();
    if (!mounted) return;
    Navigator.pushReplacementNamed(context, '/login');
  }

  @override
  Widget build(BuildContext context) {
    final user = SessionController.instance.user;

    if (user == null) {
      return const Scaffold(body: SizedBox.shrink());
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Produtos'),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 14,
                  backgroundImage: NetworkImage(user.image),
                ),
                const SizedBox(width: 6),
                Text(user.firstName),
              ],
            ),
          ),
          ValueListenableBuilder<ProductState>(
            valueListenable: widget.viewModel.state,
            builder: (context, state, _) {
              final categories =
                  state.products.map((p) => p.category).toSet().toList()
                    ..sort();
              return DropdownButton<String>(
                value: state.filterCategory,
                hint: const Text('Categoria'),
                underline: const SizedBox.shrink(),
                icon: const Icon(Icons.filter_list),
                items: [
                  const DropdownMenuItem(value: null, child: Text('Todas')),
                  ...categories.map(
                    (c) => DropdownMenuItem(value: c, child: Text(c)),
                  ),
                ],
                onChanged: widget.viewModel.filterByCategory,
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Atualizar',
            onPressed: widget.viewModel.loadProducts,
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Sair',
            onPressed: _logout,
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.pushNamed(context, '/product/form'),
        icon: const Icon(Icons.add),
        label: const Text('Novo Produto'),
      ),
      body: ValueListenableBuilder<ProductState>(
        valueListenable: widget.viewModel.state,
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
                    onPressed: widget.viewModel.loadProducts,
                    child: const Text('Tentar novamente'),
                  ),
                ],
              ),
            );
          }

          final products = state.filteredProducts;

          if (products.isEmpty) {
            return const Center(child: Text('Nenhum produto encontrado.'));
          }

          return ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 12),
            itemCount: products.length,
            itemBuilder: (context, index) {
              final product = products[index];
              return ProductCard(
                product: product,
                onTap: () {
                  if (product.id != null) {
                    Navigator.pushNamed(
                      context,
                      '/product/detail',
                      arguments: product.id,
                    );
                  }
                },
                onEdit: () => Navigator.pushNamed(
                  context,
                  '/product/form',
                  arguments: {'product': product},
                ),
                onDelete: () {
                  if (product.id != null) {
                    _confirmDelete(context, product.id!, product.title);
                  }
                },
                onToggleFavorite: () =>
                    widget.viewModel.toggleFavorite(product),
              );
            },
          );
        },
      ),
    );
  }
}
