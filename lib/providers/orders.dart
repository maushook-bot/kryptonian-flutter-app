import 'package:flutter/foundation.dart';
import 'package:flutter_complete_guide/providers/cart.dart';

class OrderItem {
  final String id;
  final double amount;
  final List<CartItem> products;
  final DateTime dateTime;

  OrderItem({
    @required this.id,
    @required this.amount,
    @required this.products,
    @required this.dateTime,
  });
}

class Orders with ChangeNotifier {
  List<OrderItem> _orders = [];
  String productTitle = '';
  int productQuantity = 0;
  double productTotal = 0.0;

  List<OrderItem> get orders {
    return [..._orders];
  }

  String getOrderTitle(int index) {
    _orders[index].products.map((item) => productTitle = item.title);
    print('OrderTitle: ${productTitle}');
    return productTitle;
  }

  int getOrderQuantity(int index) {
    _orders[index].products.map((item) => productQuantity = item.quantity);
    return productQuantity;
  }

  double getOrderProductTotal(int index) {
    _orders[index]
        .products
        .map((item) => productTotal = item.price * item.quantity);
    return productTotal;
  }

  void addOrder(List<CartItem> cartProducts, double total) {
    //_orders.add()
    _orders.insert(
      0,
      OrderItem(
        id: DateTime.now().toString(),
        amount: total,
        products: cartProducts,
        dateTime: DateTime.now(),
      ),
    );
    notifyListeners();
  }
}
