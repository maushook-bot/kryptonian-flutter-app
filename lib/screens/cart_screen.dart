import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/providers/auth.dart';
import 'package:flutter_complete_guide/providers/cart.dart' show Cart;
import 'package:flutter_complete_guide/providers/orders.dart';
import 'package:flutter_complete_guide/providers/products.dart';
import 'package:flutter_complete_guide/screens/orders_screen.dart';
import 'package:flutter_complete_guide/widgets/cart_item.dart';
import 'package:provider/provider.dart';

class CartScreen extends StatelessWidget {
  static const routeName = '/cart';

  @override
  Widget build(BuildContext context) {
    final cartData = Provider.of<Cart>(context);
    final ordersData = Provider.of<Orders>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('My Cart'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Card(
              elevation: 7,
              margin: EdgeInsets.all(12),
              child: _buildTopHeader(context, cartData, ordersData),
            ),
            SizedBox(height: 20),
            Container(
              height: 400,
              child: _buildListView(cartData),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildListView(Cart cartData) {
    return ListView.builder(
      itemCount: cartData.itemCount,
      itemBuilder: (context, index) => CartItem(
        id: cartData.items.values.toList()[index].id,
        productId: cartData.items.values.toList()[index].productId,
        title: cartData.items.values.toList()[index].title,
        price: cartData.items.values.toList()[index].price,
        quantity: cartData.items.values.toList()[index].quantity,
      ),
    );
  }

  ListView _buildListViewBody(Cart cartData) {
    return ListView.builder(
      itemCount: cartData.itemsList.length,
      itemBuilder: (context, index) => Dismissible(
        key: UniqueKey(),
        direction: DismissDirection.endToStart,
        onDismissed: (direction) =>
            cartData.deleteItems(cartData.itemsList[index].productId),
        background: Container(color: Colors.red),
        child: Card(
          margin: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
          elevation: 4,
          child: Padding(
            padding: const EdgeInsets.all(5.0),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: Theme.of(context).primaryColor,
                radius: 30,
                child: FittedBox(
                  child: Text(
                    '\$${cartData.itemsList[index].price}',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
              title: Text(
                cartData.itemsList[index].title,
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                ),
              ),
              subtitle: Text(
                  'Total: \$${cartData.getTotalItemPrice(cartData.itemsList[index])}'),
              trailing: Text(
                '${cartData.itemsList[index].quantity} x',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _showAlertDialog(BuildContext context) async {
    await showDialog<Null>(
      context: context,
      builder: (context) => AlertDialog(
        elevation: 10.4,
        title: Text('Attention Schmuck', textAlign: TextAlign.center),
        content: Text('Something Went Wrong. Try Creating Orders later!',
            textAlign: TextAlign.center),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Close'),
          ),
        ],
      ),
    );
  }

  Widget _buildTopHeader(
      BuildContext context, Cart cartData, Orders ordersData) {
    final productsData = Provider.of<Products>(context);
    return Padding(
      padding: EdgeInsets.all(8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text('Total', style: TextStyle(fontSize: 20)),
          Spacer(),
          Chip(
            label: Text(
              '\$${cartData.itemSummaryPrice.toStringAsFixed(2)}',
              style: TextStyle(color: Colors.white),
            ),
            backgroundColor: Theme.of(context).primaryColor,
          ),
          SizedBox(width: 10),
          Consumer<Orders>(
            builder: (_, orders, __) => TextButton(
              onPressed: (cartData.itemSummaryPrice <= 0 ||
                      orders.loadingState == true)
                  ? null
                  : () async {
                      try {
                        orders.setLoading();
                        String auth =
                            Provider.of<Auth>(context, listen: false).token;
                        await ordersData.addOrder(cartData.itemsList,
                            cartData.itemSummaryPrice, auth);
                        cartData.clearCart();
                        orders.resetLoading();

                        productsData.clearProductQuantity();
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              'Order Placed Successfully 🛒',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        );
                        Navigator.of(context).pushNamed(OrdersScreen.routeName);
                      } catch (error) {
                        _showAlertDialog(context);
                      }
                    },
              child: orders.loadingState == true
                  ? Center(child: CircularProgressIndicator())
                  : Text(
                      'ORDER NOW',
                      style: TextStyle(fontWeight: FontWeight.w800),
                    ),
            ),
          ),
        ],
      ),
    );
  }

  ListTile _buildTopListTile(BuildContext context, Cart cartData) {
    return ListTile(
      title: Text(
        'Total',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 20,
        ),
      ),
      trailing: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              '\$${cartData.itemSummaryPrice.toStringAsFixed(2)}',
              style: TextStyle(color: Colors.white),
            ),
          ),
          SizedBox(width: 5),
          TextButton(
            onPressed: () => {},
            child: Text(
              'ORDER NOW',
              style: TextStyle(fontWeight: FontWeight.w900),
            ),
          ),
        ],
      ),
    );
  }
}
