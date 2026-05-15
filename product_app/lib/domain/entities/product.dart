class Product {
  final int? id;
  final String title;
  final double price;
  final double rating;
  final int stock;
  final String thumbnail;
  final String description;
  final String category;
  final bool favorite;

  Product({
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

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
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

  Product copyWith({
    int? id,
    String? title,
    double? price,
    double? rating,
    int? stock,
    String? thumbnail,
    String? description,
    String? category,
    bool? favorite,
  }) {
    return Product(
      id: id ?? this.id,
      title: title ?? this.title,
      price: price ?? this.price,
      rating: rating ?? this.rating,
      stock: stock ?? this.stock,
      thumbnail: thumbnail ?? this.thumbnail,
      description: description ?? this.description,
      category: category ?? this.category,
      favorite: favorite ?? this.favorite,
    );
  }
}
