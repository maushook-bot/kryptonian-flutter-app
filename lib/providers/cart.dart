import 'package:flutter/foundation.dart';

class CartItem {
  final String id;
  final String productId;
  final String title;
  final double price;
  final int quantity;

  CartItem({
    @required this.id,
    @required this.productId,
    @required this.title,
    @required this.price,
    @required this.quantity,
  });
}

class Cart with ChangeNotifier {
  /// Map with Product Id as key & value as CarItem
  Map<String, CartItem> _items = {};

  Map<String, CartItem> get items {
    return {..._items};
  }

  List<CartItem> get itemsList {
    return _items.values.toList();
  }

  double get itemSummaryPrice {
    print('GET => itemSummaryPrice');
    var _itemPriceTotal = 0.0;

    _items.forEach(
      (key, value) {
        _itemPriceTotal += value.price * value.quantity;
      },
    );
    return _itemPriceTotal;
  }

  int get itemCount {
    return _items.length;
  }

  void deleteItems(String productId) {
    if (_items.containsKey(productId)) {
      _items.remove(productId);
    } else {
      return;
    }
    notifyListeners();
  }

  void clearCart() {
    _items = {};
    notifyListeners();
  }

  double getTotalItemPrice(CartItem item) {
    /// SubTitle => cartData.itemsList[index].price * cartData.itemsList[index].quantity
    //print('Method => getTotalItemPrice: $item');
    return item.price * item.quantity;
  }

  void addItems(String productID, String title, double price) {
    if (_items.containsKey(productID)) {
      /// If Item present in Cart then increase the quantity and price
      _items.update(
        productID,
        (existingItem) {
          return CartItem(
            id: existingItem.id,
            productId: existingItem.productId,
            title: existingItem.title,
            quantity: existingItem.quantity + 1,
            price: existingItem.price,
          );
        },
      );
    } else {
      /// Add a new Item if Product not present in Cart
      _items.putIfAbsent(
        productID,
        () => CartItem(
          id: DateTime.now().toString(),
          productId: productID,
          title: title,
          price: price,
          quantity: 1,
        ),
      );
      //print("Method => addItems: cartItem: $_items");
    }
    notifyListeners();
  }
}
