/// @@@ Kryptonian Shop APP @@@
/// @@@ version: 3.9 @@@
/// @@@ App Features: Auto Login Feature & .env
/// @@@ WebServer: FireBase @@@
/// @@@ AUTHOR: Maushook @@@
/// @@@ COPYRIGHT: Neural Bots Inc @@@

import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/pallete/deepBlue.dart';
import 'package:flutter_complete_guide/pallete/purplay.dart';
import 'package:flutter_complete_guide/providers/auth.dart';
import 'package:flutter_complete_guide/providers/cart.dart';
import 'package:flutter_complete_guide/providers/orders.dart';
import 'package:flutter_complete_guide/providers/products.dart';
import 'package:flutter_complete_guide/screens/auth_screen.dart';
import 'package:flutter_complete_guide/screens/cart_screen.dart';
import 'package:flutter_complete_guide/screens/edit_product_screen.dart';
import 'package:flutter_complete_guide/screens/orders_screen.dart';
import 'package:flutter_complete_guide/screens/product_details_screen.dart';
import 'package:flutter_complete_guide/screens/products_overview_screen.dart';
import 'package:flutter_complete_guide/screens/my_splash_screen.dart';
import 'package:flutter_complete_guide/screens/user_products_screen.dart';
import 'package:flutter_complete_guide/widgets/welcome.dart';
import 'package:provider/provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future main() async {
  await dotenv.load(fileName: "assets/.env");
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    print('DOT-ENV => ${dotenv.env['API_KEY']}');
    return MultiProvider(
      providers: [
        /// ChangeNotifierProvider Builder with Initialised Objects Products
        /// Anywhere below the child of the Providers, you can listen to the
        /// provided values using Provider.of<Products>(content)
        /// OR Using Consumer<Products>()
        ChangeNotifierProvider(create: (ctx) => Auth()),
        ChangeNotifierProxyProvider<Auth, Products>(
          create: (ctx) => Products('', '', []),
          update: (ctx, auth, previousProducts) => Products(
            auth.token,
            auth.userId,
            previousProducts == null ? [] : previousProducts.item,
          ),
        ),
        ChangeNotifierProvider(create: (ctx) => Cart()),
        ChangeNotifierProxyProvider<Auth, Orders>(
          create: (ctx) => Orders('', '', []),
          update: (ctx, auth, previousOrders) => Orders(
            auth.token,
            auth.userId,
            previousOrders == null ? [] : previousOrders.orders,
          ),
        ),
      ],
      child: Consumer<Auth>(
        builder: (context, authData, _) => MaterialApp(
          title: 'Krypton',
          theme: ThemeData(
            primarySwatch: Purplay.kToDark,
            accentColor: Colors.deepOrange,
            fontFamily: 'Lato',
          ),
          //home: authData.isAuth == true ? ProductsOverviewScreen() : Welcome(),
          routes: {
            '/': (ctx) => authData.isAuth
                ? ProductsOverviewScreen()
                : FutureBuilder(
                    future: authData.tryAutoLogin(),
                    builder: (context, snapshot) =>
                        snapshot.connectionState == ConnectionState.waiting
                            ? MySplashScreen()
                            : Welcome(),
                  ),
            AuthScreen.routeName: (ctx) => AuthScreen(),
            ProductsOverviewScreen.routeName: (ctx) => ProductsOverviewScreen(),
            ProductDetailsScreen.routeName: (ctx) => ProductDetailsScreen(),
            CartScreen.routeName: (ctx) => CartScreen(),
            OrdersScreen.routeName: (ctx) => OrdersScreen(),
            UserProductsScreen.routeName: (ctx) => UserProductsScreen(),
            EditProductScreen.routeName: (ctx) => EditProductScreen(),
          },
        ),
      ),
    );
  }
}
