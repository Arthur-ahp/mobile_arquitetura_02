import 'package:product_app/domain/entities/product.dart';

class ProductModel {
  final int? id;
  final String title;
  final double price;
  final String image;
  final String description;
  final String category;
  bool favorite;

  ProductModel({
    this.id,
    required this.title,
    required this.price,
    required this.image,
    required this.description,
    required this.category,
    this.favorite = false,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'],
      title: json['title'] ?? '',
      price: (json['price'] as num).toDouble(),
      image: json['image'] ?? '',
      description: json['description'] ?? '',
      category: json['category'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'title': title,
      'price': price,
      'image': image,
      'description': description,
      'category': category,
    };
  }

  Product toEntity() => Product(
        id: id,
        title: title,
        price: price,
        image: image,
        description: description,
        category: category,
        favorite: favorite,
      );

  factory ProductModel.fromEntity(Product p) => ProductModel(
        id: p.id,
        title: p.title,
        price: p.price,
        image: p.image,
        description: p.description,
        category: p.category,
        favorite: p.favorite,
      );
}
