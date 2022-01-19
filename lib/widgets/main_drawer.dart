import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/screens/orders_screen.dart';

class MainDrawer extends StatelessWidget {
  void _tapHandler(BuildContext context, String routeName) {
    Navigator.of(context).pushNamed(routeName);
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: <Widget>[
          Container(
            height: 120,
            width: double.infinity,
            padding: EdgeInsets.all(20),
            alignment: Alignment.centerLeft,
            color: Theme.of(context).primaryColor,
            child: Text(
              'Hello Mash!',
              style: TextStyle(
                  fontSize: 30,
                  color: Colors.white,
                  fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(height: 20),
          ListTile(
            leading: Icon(Icons.shop, size: 30),
            title: Text(
              'Shop',
              style: TextStyle(fontSize: 18, fontFamily: 'Anton-Regular'),
            ),
            onTap: () => _tapHandler(context, '/'),
          ),
          ListTile(
            leading: Icon(Icons.credit_card, size: 30),
            title: Text(
              'Orders',
              style: TextStyle(fontSize: 18, fontFamily: 'Anton-Regular'),
            ),
            onTap: () => _tapHandler(context, OrdersScreen.routeName),
          ),
        ],
      ),
    );
  }
}