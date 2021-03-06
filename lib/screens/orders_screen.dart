import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/providers/auth.dart';
import 'package:flutter_complete_guide/providers/light.dart';
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
        String auth = Provider.of<Auth>(context, listen: false).token;
        String uid = Provider.of<Auth>(context, listen: false).userId;
        Provider.of<Orders>(context, listen: false).fetchAllOrders();
      },
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print('BUILD => ORDERS SCREEN');
    final ordersData = Provider.of<Orders>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('My Orders'),
      ),
      body: RefreshIndicator(
        onRefresh: () {
          String auth = Provider.of<Auth>(context, listen: false).token;
          String uid = Provider.of<Auth>(context, listen: false).userId;
          return ordersData.fetchAllOrders();
        },
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
      //drawer: MainDrawer(),
    );
  }

  Widget _buildEmptyContent() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Nothing here ????',
            style: TextStyle(
                fontSize: 32,
                color: Provider.of<Light>(context).themeDark
                    ? Colors.white60
                    : Colors.black54),
          ),
          SizedBox(height: 3),
          Text(
            'Place an Order to get started!',
            style: TextStyle(
                fontSize: 16,
                color: Provider.of<Light>(context).themeDark
                    ? Colors.white60
                    : Colors.black54),
          )
        ],
      ),
    );
  }
}
