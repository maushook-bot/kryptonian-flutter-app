import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/pallete/deepBlue.dart';
import 'package:flutter_complete_guide/providers/auth.dart';
import 'package:flutter_complete_guide/providers/users.dart';
import 'package:flutter_complete_guide/screens/cart_screen.dart';
import 'package:flutter_complete_guide/screens/liquid_app_switch_screen.dart';
import 'package:flutter_complete_guide/screens/orders_screen.dart';
import 'package:flutter_complete_guide/screens/products_overview_screen.dart';
import 'package:flutter_complete_guide/screens/user_products_screen.dart';
import 'package:provider/provider.dart';

class MainDrawer extends StatelessWidget {
  void _tapHandler(BuildContext context, String routeName, arguments) {
    Navigator.of(context).popAndPushNamed(routeName, arguments: arguments);
  }

  @override
  Widget build(BuildContext context) {
    final bool isSeller =
        Provider.of<Users>(context, listen: false).fetchIsSeller;

    return Drawer(
      child: Column(
        children: <Widget>[
          Container(
            height: 120,
            width: double.infinity,
            padding: EdgeInsets.all(20),
            alignment: Alignment.centerLeft,
            color: Theme.of(context).appBarTheme.backgroundColor,
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
            leading: Icon(
              Icons.shop,
              size: 30,
              color: DeepBlue.kToDark.shade50,
            ),
            title: Text(
              'Shop',
              style: TextStyle(fontSize: 18, fontFamily: 'Anton-Regular'),
            ),
            onTap: () => _tapHandler(
                context, ProductsOverviewScreen.routeName, ['', false]),
          ),
          Divider(),
          ListTile(
            leading: Icon(
              Icons.category,
              size: 30,
              color: DeepBlue.kToDark.shade50,
            ),
            title: Text(
              'All Categories',
              style: TextStyle(fontSize: 18, fontFamily: 'Anton-Regular'),
            ),
            onTap: () =>
                _tapHandler(context, LiquidAppSwitchScreen.routeName, null),
          ),
          Divider(),
          ListTile(
            leading: Icon(
              Icons.credit_card,
              size: 30,
              color: DeepBlue.kToDark.shade50,
            ),
            title: Text(
              'My Orders',
              style: TextStyle(fontSize: 18, fontFamily: 'Anton-Regular'),
            ),
            onTap: () => _tapHandler(context, OrdersScreen.routeName, null),
          ),
          Divider(),
          _buildListTile(context, 'My Cart', Icons.add_shopping_cart_sharp,
              CartScreen.routeName, null),
          Divider(),
          if (isSeller == true && isSeller != null)
              _buildListTile(context, 'Manage Products',
                  Icons.manage_accounts, UserProductsScreen.routeName, null),
          if (isSeller == true && isSeller != null)
            Divider(),
          ListTile(
            leading: Icon(
              Icons.exit_to_app,
              size: 30,
              color: DeepBlue.kToDark.shade50,
            ),
            title: Text(
              'Logout',
              style: TextStyle(fontSize: 18, fontFamily: 'Anton-Regular'),
            ),
            onTap: () {
              Navigator.of(context).pop();
              Navigator.of(context).pushReplacementNamed('/');
              Provider.of<Auth>(context, listen: false).logout();
            },
          ),
        ],
      ),
    );
  }

  ListTile _buildListTile(
      BuildContext context, String title, IconData icon, route, arguments) {
    return ListTile(
      leading: Icon(
        icon,
        size: 30,
        color: DeepBlue.kToDark.shade50,
      ),
      title: Text(
        title,
        style: TextStyle(fontSize: 18, fontFamily: 'Anton-Regular'),
      ),
      onTap: () => _tapHandler(context, route, arguments),
    );
  }
}
