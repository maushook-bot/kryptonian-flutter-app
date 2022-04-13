import 'dart:async';

import 'package:animated_theme_switcher/animated_theme_switcher.dart';
import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/helpers/theme_config.dart';
import 'package:flutter_complete_guide/providers/auth.dart';
import 'package:flutter_complete_guide/providers/cart.dart';
import 'package:flutter_complete_guide/providers/light.dart';
import 'package:flutter_complete_guide/providers/products.dart';
import 'package:flutter_complete_guide/screens/cart_screen.dart';
import 'package:flutter_complete_guide/widgets/badge.dart';
import 'package:flutter_complete_guide/widgets/main_drawer.dart';
import 'package:flutter_complete_guide/widgets/products_grid.dart';
import 'package:provider/provider.dart';

enum FilterOptions {
  favorites,
  all,
}

class ProductsOverviewScreen extends StatefulWidget {
  static const routeName = '/product-overview';

  @override
  State<ProductsOverviewScreen> createState() => _ProductsOverviewScreenState();
}

class _ProductsOverviewScreenState extends State<ProductsOverviewScreen> {
  bool _showFavoriteOnly = false;
  var _isInit = true;
  var _isLoading = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void didChangeDependencies() async {
    // TODO: implement didChangeDependencies
    bool isAuth = Provider.of<Auth>(context, listen: false).isAuth;
    String uid = Provider.of<Auth>(context, listen: false).userId;
    if (_isInit == true) {
      setState(() {
        _isLoading = true;
      });

      try {
        await Provider.of<Products>(context).fetchProduct();
      } catch (error) {
        setState(() {
          _isLoading = false;
        });
        print('PRODUCTS ERROR => $error');
        showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            elevation: 10.4,
            contentPadding: EdgeInsets.all(30.0),
            title: Text('Attention', textAlign: TextAlign.center),
            content: Text(
              'Something went wrong, ${error}',
              textAlign: TextAlign.center,
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(ctx).pop(false),
                child: Text('Close'),
              ),
            ],
          ),
        );
      }
    }

    setState(() {
      _isLoading = false;
    });
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    print('BUILD => PRODUCT OVERVIEW SCREEN');
    final lightData = Provider.of<Light>(context);
    final isDark = lightData.themeDark;
    final List data = ModalRoute.of(context).settings.arguments;
    String categoryId = data[0];
    bool categoryFlag = data[1];

    return ThemeSwitchingArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Krypton'),
          actions: <Widget>[
            PopupMenuButton(
              icon: Icon(Icons.more_vert),
              onSelected: (FilterOptions selectedValue) {
                setState(() {
                  if (selectedValue == FilterOptions.favorites) {
                    _showFavoriteOnly = true;
                  } else {
                    _showFavoriteOnly = false;
                  }
                });
              },
              itemBuilder: (_) => [
                PopupMenuItem(
                  child: Text('Only Favorites'),
                  value: FilterOptions.favorites,
                ),
                PopupMenuItem(
                  child: Text('Show All'),
                  value: FilterOptions.all,
                ),
              ],
            ),
            Consumer<Cart>(
              builder: (_, cartData, ch) => Badge(
                child: ch,
                value: cartData.itemCount.toString(),
              ),
              child: IconButton(
                icon: Icon(Icons.shopping_cart),
                onPressed: () =>
                    Navigator.of(context).pushNamed(CartScreen.routeName),
              ),
            ),
            ThemeSwitcher(
              clipper: ThemeSwitcherCircleClipper(),
              builder: (ctx) => IconButton(
                icon: Icon(isDark ? Icons.wb_sunny : Icons.nights_stay_sharp),
                color: isDark ? Colors.yellow : Colors.grey,
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
          ],
        ),
        body: _isLoading == true
            ? Center(
                child: CircularProgressIndicator(),
              )
            : productsGrid(
                showFavoriteOnly: _showFavoriteOnly,
                categoryId: categoryId,
                categoryFlag: categoryFlag,
              ),
        //drawer: MainDrawer(),
      ),
    );
  }
}
