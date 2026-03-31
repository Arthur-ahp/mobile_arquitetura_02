import 'package:flutter/material.dart';
import 'package:product_app/domain/entities/product.dart';
import 'package:product_app/presentation/viewmodels/product_viewmodel.dart';
import 'package:product_app/presentation/widgets/custom_form_field.dart';

class ProductFormPage extends StatefulWidget {
  final ProductViewModel viewModel;
  final Product? product; // null = cadastro, não-null = edição

  const ProductFormPage({
    super.key,
    required this.viewModel,
    this.product,
  });

  @override
  State<ProductFormPage> createState() => _ProductFormPageState();
}

class _ProductFormPageState extends State<ProductFormPage> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  late final TextEditingController _titleController;
  late final TextEditingController _priceController;
  late final TextEditingController _descriptionController;
  late final TextEditingController _categoryController;
  late final TextEditingController _imageController;

  bool get _isEditing => widget.product != null;

  @override
  void initState() {
    super.initState();
    final p = widget.product;
    _titleController = TextEditingController(text: p?.title ?? '');
    _priceController = TextEditingController(
        text: p != null ? p.price.toStringAsFixed(2) : '');
    _descriptionController = TextEditingController(text: p?.description ?? '');
    _categoryController = TextEditingController(text: p?.category ?? '');
    _imageController = TextEditingController(text: p?.image ?? '');
  }

  @override
  void dispose() {
    _titleController.dispose();
    _priceController.dispose();
    _descriptionController.dispose();
    _categoryController.dispose();
    _imageController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);

    final product = Product(
      id: widget.product?.id,
      title: _titleController.text.trim(),
      price: double.parse(_priceController.text.trim().replaceAll(',', '.')),
      description: _descriptionController.text.trim(),
      category: _categoryController.text.trim(),
      image: _imageController.text.trim(),
    );

    bool ok;
    if (_isEditing) {
      ok = await widget.viewModel.updateProduct(product);
    } else {
      ok = await widget.viewModel.createProduct(product);
    }

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(ok
              ? (_isEditing ? 'Produto atualizado!' : 'Produto cadastrado!')
              : 'Erro ao salvar produto.'),
        ),
      );
      if (ok) Navigator.pop(context);
    }

    if (mounted) setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? 'Editar Produto' : 'Novo Produto'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              CustomFormField(
                label: 'Título',
                controller: _titleController,
                hint: 'Ex: Camiseta básica branca',
                validator: (v) =>
                    (v == null || v.isEmpty) ? 'Informe o título' : null,
              ),
              CustomFormField(
                label: 'Preço',
                controller: _priceController,
                hint: 'Ex: 49.90',
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                validator: (v) {
                  if (v == null || v.isEmpty) return 'Informe o preço';
                  if (double.tryParse(v.replaceAll(',', '.')) == null) {
                    return 'Preço inválido';
                  }
                  return null;
                },
              ),
              CustomFormField(
                label: 'Categoria',
                controller: _categoryController,
                hint: "Ex: men's clothing",
                validator: (v) =>
                    (v == null || v.isEmpty) ? 'Informe a categoria' : null,
              ),
              CustomFormField(
                label: 'Descrição',
                controller: _descriptionController,
                hint: 'Descreva o produto...',
                maxLines: 4,
                validator: (v) =>
                    (v == null || v.isEmpty) ? 'Informe a descrição' : null,
              ),
              CustomFormField(
                label: 'URL da Imagem',
                controller: _imageController,
                hint: 'https://...',
                validator: (v) =>
                    (v == null || v.isEmpty) ? 'Informe a URL da imagem' : null,
              ),
              const SizedBox(height: 8),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: _isLoading ? null : _submit,
                  style: FilledButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: _isLoading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                              strokeWidth: 2, color: Colors.white),
                        )
                      : Text(
                          _isEditing ? 'Salvar Alterações' : 'Cadastrar Produto',
                          style: const TextStyle(fontSize: 16),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
