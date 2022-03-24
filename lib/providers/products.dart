import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/providers/product.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class Products with ChangeNotifier {
  List<Product> _items = [];

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

  Future<void> fetchProduct(auth) async {
    print('FETCH => PRODUCTS');
    final List productIdList = [];
    final url = Uri.https(
        'kryptonian-flutter-app-default-rtdb.europe-west1.firebasedatabase.app',
        '/products.json', {'auth': auth});

    try {
      final response = await http.get(url);
      final Map<String, dynamic> result = json.decode(response.body);
      final List<Product> LoadedProduct = [];
      print('LoadedProduct => ${result}');
      result['error'] == 'Permission denied'
          ? throw 'Authentication Failed Permission Denied!'
          : result.forEach(
              (key, product) {
                LoadedProduct.add(
                  Product(
                    id: key,
                    title: product['title'],
                    price: product['price'],
                    description: product['description'],
                    isFavorite: product['isFavorite'],
                    imageUrl: product['imageUrl'],
                  ),
                );
              },
            );
      _items = LoadedProduct;
      print(_items);
      notifyListeners();
    } catch (error) {
      print('ERROR => $error');
      throw error;
    }
  }

  Future<void> addProduct(Product newProduct, String auth) async {
    String newProductId;
    final url = Uri.https(
        'kryptonian-flutter-app-default-rtdb.europe-west1.firebasedatabase.app',
        '/products.json', {'auth': auth});
    try {
      final response = await http.post(
        url,
        body: json.encode(
          {
            'title': newProduct.title,
            'price': newProduct.price,
            'description': newProduct.description,
            'qty': newProduct.qty,
            'imageUrl': newProduct.imageUrl,
            'isFavorite': newProduct.isFavorite,
          },
        ),
      );
      newProductId = json.decode(response.body)['name'];

      /// ADD NEW PRODUCT
      print('ADD => Product');
      final product = Product(
        id: newProductId,
        title: newProduct.title,
        price: newProduct.price,
        description: newProduct.description,
        imageUrl: newProduct.imageUrl,
      );
      _items.add(product);
      notifyListeners();
    } catch (error) {
      print('ERROR: ${error}');
      throw error;
    }
  }

  Future<void> deleteProductTwin(String productId, String auth) async {
    // TODO: Alternate Approach to Delete!
    print('DELETE => Product: ${productId}');
    final url = Uri.https(
        'kryptonian-flutter-app-default-rtdb.europe-west1.firebasedatabase.app',
        '/products/${productId}.json', {'auth': auth});
    final response = await http.delete(url);

    print('DELETE Response => ${response.statusCode}');
    if (response.statusCode == 200) {
      _items.removeWhere((product) => product.id == productId);
    } else if (response.statusCode >= 400) {
      print('DELETE => Failed: ${response.body}');
      throw HttpException('Delete Failed. Try Again Later!');
    }
    notifyListeners();
  }

  Future<void> deleteProduct(String productId, String auth) async {
    print('DELETE => Product: ${productId}');
    final existingProdIndex = _items.indexWhere((item) => item.id == productId);
    Product existingProduct = _items[existingProdIndex];
    _items.removeWhere((product) => product.id == productId);

    final url = Uri.https(
        'kryptonian-flutter-app-default-rtdb.europe-west1.firebasedatabase.app',
        '/products/${productId}.json', {'auth': auth});

    final response = await http.delete(url);
    print('DELETE Response => ${response.statusCode}');
    if (response.statusCode == 200) {
      existingProduct = null;
    } else if (response.statusCode >= 400) {
      print('DELETE => Failed: ${response.body}');
      _items.insert(existingProdIndex, existingProduct);
      notifyListeners();
      throw HttpException('Delete Failed. Try Again Later!');
    }
    notifyListeners();
  }

  Future<void> updateProduct(String id, Product updatedProduct, String auth) async {
    //TODO: Work on this!!
    print('UPDATE => Product');
    final productIndex = _items.indexWhere((product) => product.id == id);
    if (productIndex >= 0) {
      final url = Uri.https(
          'kryptonian-flutter-app-default-rtdb.europe-west1.firebasedatabase.app',
          '/products/${id}.json', {'auth': auth});
      final response = await http.patch(
        url,
        body: json.encode({
          'title': updatedProduct.title,
          'price': updatedProduct.price,
          'description': updatedProduct.description,
          'qty': updatedProduct.qty,
          'imageUrl': updatedProduct.imageUrl,
        }),
      );
      print(response.body);
      _items[productIndex] = updatedProduct;
      notifyListeners();
    }
  }
}
