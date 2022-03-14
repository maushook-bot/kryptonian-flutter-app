import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/providers/product.dart';

class Products with ChangeNotifier {
  List<Product> _items = [
    Product(
      id: 'p1',
      title: 'Red Shirt',
      description: 'A red shirt - it is pretty red!',
      price: 29.99,
      imageUrl:
          'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
      qty: 0,
    ),
    Product(
      id: 'p2',
      title: 'Trousers',
      description: 'A nice pair of trousers.',
      price: 59.99,
      imageUrl:
          'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
      qty: 0,
    ),
    Product(
      id: 'p3',
      title: 'Yellow Scarf',
      description: 'Warm and cozy - exactly what you need for the winter.',
      price: 19.99,
      imageUrl:
          'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
      qty: 0,
    ),
    Product(
      id: 'p4',
      title: 'A Pan',
      description: 'Prepare any meal you want.',
      price: 49.99,
      imageUrl:
          'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
      qty: 0,
    ),
  ];

  List<Product> get item {
    return [..._items];
  }

  List<Product> get favoriteItems {
    return _items.where((product) => product.isFavorite == true).toList();
  }

  Product findById(String id) {
    return _items.firstWhere((product) => product.id == id);
  }

  void addProductQuantity(String id, int index) {
    _items[index].id == id ? _items[index].qty += 1 : 0;
    notifyListeners();
  }

  void decreaseProductQuantity(String id, int index) {
    (_items[index].id == id) && (_items[index].qty > 0)
        ? _items[index].qty -= 1
        : 0;
    notifyListeners();
  }

  void clearUnitProductQuantity(String productId) {
    final filteredItem = _items.firstWhere((item) => item.id == productId);
    filteredItem.qty = 0;
    notifyListeners();
  }

  void clearProductQuantity() {
    _items.forEach((product) {
      product.qty = 0;
    });
    notifyListeners();
  }

  void addProduct(Product newProduct) {
    /// ADD NEW PRODUCT
    print('ADD => Product');
    final product = Product(
      id: DateTime.now().toString(),
      title: newProduct.title,
      price: newProduct.price,
      description: newProduct.description,
      imageUrl: newProduct.imageUrl,
    );
    _items.add(product);
    notifyListeners();
  }

  void deleteProduct(String productId) {
    print('DELETE => Product: ${productId}');
    _items.removeWhere((product) => product.id == productId);
    notifyListeners();
  }

  void updateProduct(String id, Product updatedProduct) {
    //TODO: Work on this!!
    print('EDIT => Product');
    final productIndex = _items.indexWhere((product) => product.id == id);
    _items[productIndex] = updatedProduct;
    notifyListeners();
  }
}
