import 'dart:async';

import 'package:animated_theme_switcher/animated_theme_switcher.dart';
import 'package:flutter/material.dart';
import 'package:fab_circular_menu/fab_circular_menu.dart';
import 'package:flutter_complete_guide/helpers/theme_config.dart';
import 'package:flutter_complete_guide/pallete/deepBlue.dart';
import 'package:flutter_complete_guide/providers/auth.dart';
import 'package:flutter_complete_guide/providers/light.dart';
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
      builder: (context) => FabCircularMenu(
        key: fabKey,
        alignment: Alignment.bottomRight,
        ringColor: Colors.black.withAlpha(180),
        ringDiameter: 500.0,
        ringWidth: 160.0,
        fabSize: 64.0,
        fabElevation: 32.0,
        fabIconBorder: CircleBorder(),
        fabColor: Colors.deepOrangeAccent,
        fabOpenIcon: Icon(Icons.menu, color: DeepBlue.kToDark),
        fabCloseIcon: Icon(Icons.close, color: DeepBlue.kToDark),
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
            onPressed: () => _tapHandler(
                context, ProductsOverviewScreen.routeName, ['', false]),
            icon: Icon(Icons.shop, color: Colors.deepOrange, size: 30),
          ),
          IconButton(
            onPressed: () =>
                _tapHandler(context, LiquidAppSwitchScreen.routeName, null),
            icon: Icon(Icons.category, color: Colors.deepOrange, size: 30),
          ),
          IconButton(
            onPressed: () => _tapHandler(context, OrdersScreen.routeName, null),
            icon: Icon(Icons.credit_card, color: Colors.deepOrange, size: 30),
          ),
          IconButton(
            onPressed: () {
              _tapHandler(context, CartScreen.routeName, null);
            },
            icon: Icon(
              Icons.add_shopping_cart_sharp,
              color: Colors.deepOrange,
              size: 30,
            ),
          ),
          IconButton(
            onPressed: () =>
                _tapHandler(context, UserProductsScreen.routeName, null),
            icon:
                Icon(Icons.manage_accounts, color: Colors.deepOrange, size: 30),
          ),
          IconButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).pushNamed('/');
              Provider.of<Auth>(context, listen: false).logout();
            },
            icon: Icon(Icons.exit_to_app, color: Colors.deepOrange, size: 30),
          ),
        ],
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
