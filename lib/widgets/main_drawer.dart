import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/pallete/deepBlue.dart';
import 'package:flutter_complete_guide/providers/auth.dart';
import 'package:flutter_complete_guide/providers/products.dart';
import 'package:flutter_complete_guide/providers/users.dart';
import 'package:flutter_complete_guide/screens/cart_screen.dart';
import 'package:flutter_complete_guide/screens/categories_screen.dart';
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
    final username = Provider.of<Users>(context, listen: false).userName;
    return Consumer<Users>(
      builder: (context, userData, _) => Drawer(
        child: Column(
          children: <Widget>[
            Container(
              height: 120,
              width: double.infinity,
              padding: EdgeInsets.all(20),
              alignment: Alignment.centerLeft,
              color: Theme.of(context).appBarTheme.backgroundColor,
              child: Text(
                'Hello ${username ?? ''}!',
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
                  _tapHandler(context, CategoriesScreen.routeName, null),
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
                CartScreen.routeName, null, DeepBlue.kToDark.shade50),
            Divider(),
            if (userData.fetchIsSeller == true &&
                userData.fetchIsSeller != null)
              _buildListTile(context, 'Manage Products', Icons.manage_accounts,
                  UserProductsScreen.routeName, null, Colors.red),
            if (userData.fetchIsSeller == true &&
                userData.fetchIsSeller != null)
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
      ),
    );
  }

  ListTile _buildListTile(BuildContext context, String title, IconData icon,
      route, arguments, Color color) {
    return ListTile(
      leading: Icon(
        icon,
        size: 30,
        color: color,
      ),
      title: Text(
        title,
        style: TextStyle(fontSize: 18, fontFamily: 'Anton-Regular'),
      ),
      onTap: () => _tapHandler(context, route, arguments),
    );
  }
}
