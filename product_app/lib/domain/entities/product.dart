class Product {
  final int? id;
  final String title;
  final double price;
  final String image;
  final String description;
  final String category;
  bool favorite;

  Product({
    this.id,
    required this.title,
    required this.price,
    required this.image,
    required this.description,
    required this.category,
    this.favorite = false,
  });

  Product copyWith({
    int? id,
    String? title,
    double? price,
    String? image,
    String? description,
    String? category,
    bool? favorite,
  }) {
    return Product(
      id: id ?? this.id,
      title: title ?? this.title,
      price: price ?? this.price,
      image: image ?? this.image,
      description: description ?? this.description,
      category: category ?? this.category,
      favorite: favorite ?? this.favorite,
    );
  }
}
