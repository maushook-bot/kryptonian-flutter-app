import 'package:flutter/foundation.dart';

class Product with ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  final String categoryId;
  bool isFavorite;
  int qty;

  Product({
    @required this.id,
    @required this.title,
    @required this.description,
    @required this.price,
    @required this.imageUrl,
    @required this.categoryId,
    this.isFavorite = false,
    this.qty = 0,
  });

  void toggleFavoriteStatus() {
    isFavorite = !isFavorite;
    //print('favorite: $isFavorite');
    notifyListeners();
  }

  Product copyWith({
    String id,
    String title,
    String description,
    double price,
    String imageUrl,
    String catId,
  }) {
    return Product(
      id: id ?? this.id,
      title: title ?? this.title,
      price: price ?? this.price,
      description: description ?? this.description,
      imageUrl: imageUrl ?? this.imageUrl,
      categoryId: catId ?? this.categoryId,
    );
  }
}
