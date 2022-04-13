import 'dart:async';

import 'package:animated_theme_switcher/animated_theme_switcher.dart';
import 'package:flutter/material.dart';
import 'package:fab_circular_menu/fab_circular_menu.dart';
import 'package:flutter_complete_guide/helpers/theme_config.dart';
import 'package:flutter_complete_guide/pallete/deepBlue.dart';
import 'package:flutter_complete_guide/providers/auth.dart';
import 'package:flutter_complete_guide/providers/light.dart';
import 'package:flutter_complete_guide/providers/users.dart';
import 'package:flutter_complete_guide/screens/cart_screen.dart';
import 'package:flutter_complete_guide/screens/categories_screen.dart';
import 'package:flutter_complete_guide/screens/liquid_app_switch_screen.dart';
import 'package:flutter_complete_guide/screens/orders_screen.dart';
import 'package:flutter_complete_guide/screens/products_overview_screen.dart';
import 'package:flutter_complete_guide/screens/user_products_screen.dart';
import 'package:provider/provider.dart';

class CircularMenu extends StatelessWidget {
  final GlobalKey<FabCircularMenuState> fabKey = GlobalKey();

  void _tapHandler(BuildContext context, String routeName, arguments) {
    Navigator.of(context).pushNamed(routeName, arguments: arguments);
  }

  @override
  Widget build(BuildContext context) {
    final lightData = Provider.of<Light>(context, listen: false);
    final isDark = lightData.themeDark;
    return Builder(
      builder: (context) => Consumer<Users>(
        builder: (ctx, userData, _) => FabCircularMenu(
          key: fabKey,
          alignment: Alignment.bottomRight,
          ringColor: Colors.black.withAlpha(180),
          ringDiameter: 500.0,
          ringWidth: 160.0,
          fabSize: 64.0,
          fabElevation: 32.0,
          fabIconBorder: CircleBorder(),
          fabColor: isDark ? Colors.deepOrangeAccent : DeepBlue.kToDark,
          fabOpenIcon: Icon(
            Icons.menu,
            color: isDark ? DeepBlue.kToDark : Colors.deepOrangeAccent,
            size: 30,
          ),
          fabCloseIcon: Icon(
            Icons.close,
            color: isDark ? DeepBlue.kToDark : Colors.deepOrangeAccent,
            size: 30,
          ),
          fabMargin: const EdgeInsets.all(16.0),
          animationDuration: const Duration(milliseconds: 800),
          animationCurve: Curves.easeInOutCirc,
          onDisplayChange: (isOpen) {
            //_showSnackBar(context, "The menu is ${isOpen ? "open" : "closed"}");
          },
          children: <Widget>[
            ThemeSwitcher(
              clipper: ThemeSwitcherBoxClipper(),
              builder: (ctx) => IconButton(
                icon: Icon(isDark ? Icons.wb_sunny : Icons.nights_stay_sharp),
                color: isDark ? Colors.yellow : Colors.white,
                onPressed: () {
                  lightData.toggleLights();
                  Timer(
                    Duration(milliseconds: 50),
                    () => ThemeSwitcher.of(ctx)
                        .changeTheme(theme: isDark ? dayTheme : nightTheme),
                  );
                },
              ),
            ),
            IconButton(
              onPressed: () {
                _tapHandler(ctx, ProductsOverviewScreen.routeName, ['', false]);
                fabKey.currentState.close();
              },
              icon: Icon(Icons.shop,
                  color: isDark ? Colors.deepOrange : Colors.lightBlueAccent,
                  size: 30),
            ),
            IconButton(
              onPressed: () {
                _tapHandler(ctx, CategoriesScreen.routeName, null);
                fabKey.currentState.close();
              },
              icon: Icon(Icons.category,
                  color: isDark ? Colors.deepOrange : Colors.lightBlueAccent,
                  size: 30),
            ),
            IconButton(
              onPressed: () {
                _tapHandler(ctx, OrdersScreen.routeName, null);
                fabKey.currentState.close();
              },
              icon: Icon(Icons.credit_card,
                  color: isDark ? Colors.deepOrange : Colors.lightBlueAccent,
                  size: 30),
            ),
            IconButton(
              onPressed: () {
                _tapHandler(ctx, CartScreen.routeName, null);
                fabKey.currentState.close();
              },
              icon: Icon(
                Icons.add_shopping_cart_sharp,
                color: isDark ? Colors.deepOrange : Colors.lightBlueAccent,
                size: 30,
              ),
            ),
            if (userData.fetchIsSeller == true &&
                userData.fetchIsSeller != null)
              IconButton(
                onPressed: () {
                  _tapHandler(ctx, UserProductsScreen.routeName, null);
                  fabKey.currentState.close();
                },
                icon: Icon(Icons.manage_accounts,
                    color: isDark ? Colors.teal : Colors.red, size: 30),
              ),
            IconButton(
              onPressed: () {
                Navigator.of(ctx).pop();
                Navigator.of(ctx).pushNamed('/');
                Provider.of<Auth>(ctx, listen: false).logout();
                fabKey.currentState.close();
              },
              icon: Icon(Icons.exit_to_app,
                  color: isDark ? Colors.deepOrange : Colors.lightBlueAccent,
                  size: 30),
            ),
          ],
        ),
      ),
    );
  }

  void _showSnackBar(BuildContext context, String message) {
    Scaffold.of(context).showSnackBar(SnackBar(
      backgroundColor: Colors.black54,
      content: Text(message),
      duration: const Duration(milliseconds: 1000),
    ));
  }
}
