import 'package:flutter/foundation.dart';
import 'package:flutter_complete_guide/providers/product.dart';

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
  int item_qty = 0;

  Map<String, CartItem> get items {
    return {..._items};
  }

  List<CartItem> get itemsList {
    return _items.values.toList();
  }

  double get itemSummaryPrice {
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

  int getItemQuantity(String productId) {
    _items.forEach(
      (key, item) {
        if (item.productId == productId) {
          item_qty = item.quantity;
        }
      },
    );
    if (_items.containsKey(productId)) {
      return item_qty;
    } else {
      return 0;
    }
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

  void clearSingleItem(String productId) {
    if (!_items.containsKey(productId)) {
      return;
    }
    if (_items[productId].quantity > 1) {
      _items.update(
        productId,
        (item) => CartItem(
          id: item.id,
          productId: item.productId,
          title: item.title,
          price: item.price,
          quantity: item.quantity - 1,
        ),
      );
    } else {
      _items.remove(productId);
    }
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
      /// map.update(key, (value) => newValue )
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

  void reduceItems(String productID) {
    if (_items.containsKey(productID) && _items[productID].quantity > 1) {
      /// If Item present in Cart then decrease the quantity and price
      /// map.update(key, (value) => newValue )
      _items.update(
        productID,
        (existingItem) {
          return CartItem(
            id: existingItem.id,
            productId: existingItem.productId,
            title: existingItem.title,
            quantity: existingItem.quantity > 0 ? existingItem.quantity - 1 : 0,
            price: existingItem.price,
          );
        },
      );
    } else {
      _items.remove(productID);
    }
    notifyListeners();
  }

  void updateItems(String productId, Product updatedProduct) {
    if (_items.containsKey(productId)) {
      _items.update(
        productId,
        (existingItem) {
          return CartItem(
            id: existingItem.id,
            productId: productId,
            title: updatedProduct.title,
            price: updatedProduct.price,
            quantity: existingItem.quantity,
          );
        },
      );
    }
    notifyListeners();
  }
}
