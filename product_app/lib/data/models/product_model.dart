import 'package:product_app/domain/entities/product.dart';

class ProductModel {
  final int? id;
  final String title;
  final double price;
  final double rating;
  final int stock;
  final String thumbnail;
  final String description;
  final String category;
  final bool favorite;

  ProductModel({
    this.id,
    required this.title,
    required this.price,
    this.rating = 0,
    this.stock = 0,
    required this.thumbnail,
    required this.description,
    required this.category,
    this.favorite = false,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'],
      title: json['title'] ?? '',
      price: ((json['price'] ?? 0) as num).toDouble(),
      rating: ((json['rating'] ?? 0) as num).toDouble(),
      stock: json['stock'] ?? 0,
      thumbnail: json['thumbnail'] ?? json['image'] ?? '',
      description: json['description'] ?? '',
      category: json['category'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'title': title,
      'price': price,
      'rating': rating,
      'stock': stock,
      'thumbnail': thumbnail,
      'description': description,
      'category': category,
    };
  }

  Product toEntity() => Product(
    id: id,
    title: title,
    price: price,
    rating: rating,
    stock: stock,
    thumbnail: thumbnail,
    description: description,
    category: category,
    favorite: favorite,
  );

  factory ProductModel.fromEntity(Product p) => ProductModel(
    id: p.id,
    title: p.title,
    price: p.price,
    rating: p.rating,
    stock: p.stock,
    thumbnail: p.thumbnail,
    description: p.description,
    category: p.category,
    favorite: p.favorite,
  );
}
