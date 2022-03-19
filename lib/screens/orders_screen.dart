import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/providers/orders.dart';
import 'package:flutter_complete_guide/widgets/main_drawer.dart';
import 'package:flutter_complete_guide/widgets/orders_item.dart';
import 'package:provider/provider.dart';

class OrdersScreen extends StatefulWidget {
  static const routeName = '/orders';

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  @override
  void initState() {
    // TODO: implement initState
    Future.delayed(Duration.zero).then(
      (_) {
        Provider.of<Orders>(context, listen: false).fetchAllOrders();
      },
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final ordersData = Provider.of<Orders>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('My Orders'),
      ),
      body: RefreshIndicator(
        onRefresh: () => ordersData.fetchAllOrders(),
        child: ordersData.orders.length == 0
            ? _buildEmptyContent()
            : ListView.builder(
                itemCount: ordersData.orders.length,
                itemBuilder: (context, index) => OrdersItem(
                  id: ordersData.orders[index].id,
                  amount: ordersData.orders[index].amount,
                  dateTime: ordersData.orders[index].dateTime,
                  products: ordersData.orders[index].products,
                ),
              ),
      ),
      drawer: MainDrawer(),
    );
  }

  Widget _buildEmptyContent() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Nothing here!',
            style: TextStyle(fontSize: 32, color: Colors.black54),
          ),
          SizedBox(height: 10),
          Text(
            'Add Items to Cart and place an Order to get started',
            style: TextStyle(fontSize: 16, color: Colors.black54),
          )
        ],
      ),
    );
  }
}
