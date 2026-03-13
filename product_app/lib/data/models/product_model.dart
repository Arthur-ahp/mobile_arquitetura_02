class ProductModel {
  final int id;
  final String title;
  final double price;
  final String image;
  bool favorite;

  ProductModel({
    required this.id,
    required this.title,
    required this.price,
    required this.image,
    this.favorite = false,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json["id"],
      title: json["title"],
      price: json["price"].toDouble(),
      image: json["image"],
      favorite: false,
    );
  }
}