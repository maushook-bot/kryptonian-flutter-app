import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_complete_guide/models/http_exception.dart';
import 'package:flutter_complete_guide/providers/cart.dart';
import 'package:http/http.dart' as http;

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
  bool isLoading;

  void setLoading() {
    isLoading = true;
    notifyListeners();
  }

  void resetLoading() {
    isLoading = false;
    notifyListeners();
  }

  bool get loadingState {
    return isLoading;
  }

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

  Future<void> fetchAllOrders(String auth) async {
    // TODO:
    final url = Uri.https(
        'kryptonian-flutter-app-default-rtdb.europe-west1.firebasedatabase.app',
        '/orders.json', {'auth': auth});

    try {
      final response = await http.get(url);
      final Map<String, dynamic> result = json.decode(response.body);
      final List<OrderItem> loadedOrder = [];
      print(result);

      if (result != null) {
        result.forEach(
          (orderId, order) {
            loadedOrder.add(
              OrderItem(
                id: orderId,
                amount: order['amount'],
                dateTime: DateTime.parse(order['dateTime']),
                products: (order['products'] as List<dynamic>)
                    .map(
                      (cartItem) => CartItem(
                        id: cartItem['id'],
                        title: cartItem['title'],
                        price: cartItem['price'],
                        quantity: cartItem['quantity'],
                        productId: cartItem['productId'],
                      ),
                    )
                    .toList(),
              ),
            );
          },
        );
      }
      _orders = loadedOrder.reversed.toList();
      notifyListeners();
    } catch (error) {
      throw error;
    }
    notifyListeners();
  }

  Future<void> addOrder(List<CartItem> cartProducts, double total, auth) async {
    // TODO:
    final timeStamp = DateTime.now();
    final url = Uri.https(
        'kryptonian-flutter-app-default-rtdb.europe-west1.firebasedatabase.app',
        '/orders.json', {'auth': auth});

    final response = await http.post(
      url,
      body: json.encode(
        {
          'amount': total,
          'dateTime': timeStamp.toIso8601String(),
          'products': cartProducts.map(
            (item) {
              return {
                'id': item.id,
                'productId': item.productId,
                'title': item.title,
                'price': item.price,
                'quantity': item.quantity,
              };
            },
          ).toList(),
        },
      ),
    );

    if (response.statusCode == 200) {
      final orderId = json.decode(response.body)['name'];
      _orders.insert(
        0,
        OrderItem(
          id: orderId,
          amount: total,
          products: cartProducts,
          dateTime: timeStamp,
        ),
      );
      notifyListeners();
    } else if (response.statusCode >= 400) {
      print('ORDER INSERT => Failed');
      throw HttpException(message: 'Insert Failed!');
    }
  }
}
