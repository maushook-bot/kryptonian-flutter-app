/// @@@ Kryptonian Shop APP @@@
/// @@@ version: 4.5 @@@
/// @@@ App Features: Dark and Light Mode Switch | FLUTTER-42 ✨
/// @@@ WebServer: FireBase @@@
/// @@@ AUTHOR: Maushook @@@
/// @@@ COPYRIGHT: Neural Bots Inc @@@

import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/pallete/deepBlue.dart';
import 'package:flutter_complete_guide/providers/auth.dart';
import 'package:flutter_complete_guide/providers/cart.dart';
import 'package:flutter_complete_guide/providers/categories.dart';
import 'package:flutter_complete_guide/providers/light.dart';
import 'package:flutter_complete_guide/providers/orders.dart';
import 'package:flutter_complete_guide/providers/products.dart';
import 'package:flutter_complete_guide/screens/auth_screen.dart';
import 'package:flutter_complete_guide/screens/cart_screen.dart';
import 'package:flutter_complete_guide/screens/categories_screen.dart';
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
        ChangeNotifierProvider(create: (ctx) => Light()),
        ChangeNotifierProvider(create: (ctx) => Categories()),
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
        builder: (ctx, authData, _) => MaterialApp(
          title: 'Krypton',
          theme: ThemeData(
            primarySwatch: DeepBlue.kToDark,
            accentColor: Colors.deepOrange,
            fontFamily: 'Lato',
            appBarTheme: AppBarTheme(
              backgroundColor: DeepBlue.kToDark,
            ),
          ),
          //home: authData.isAuth == true ? ProductsOverviewScreen() : Welcome(),
          routes: {
            '/': (ctx) => authData.isAuth
                ? CategoriesScreen()
                : FutureBuilder(
                    future: authData.tryAutoLogin(),
                    builder: (context, snapshot) =>
                        snapshot.connectionState == ConnectionState.waiting
                            ? MySplashScreen()
                            : Welcome(),
                  ),
            CategoriesScreen.routeName: (ctx) => CategoriesScreen(),
            AuthScreen.routeName: (ctx) => AuthScreen(),
            ProductsOverviewScreen.routeName: (ctx) => ProductsOverviewScreen(),
            ProductDetailsScreen.routeName: (ctx) => ProductDetailsScreen(),
            CartScreen.routeName: (ctx) => CartScreen(),
            OrdersScreen.routeName: (ctx) => OrdersScreen(),
            UserProductsScreen.routeName: (ctx) => UserProductsScreen(),
            EditProductScreen.routeName: (ctx) => EditProductScreen(),
          },
          darkTheme: ThemeData(
            brightness: Brightness.dark,
            primarySwatch: DeepBlue.kToDark,
            canvasColor: Colors.black,
            cardColor: DeepBlue.kToDark.shade500,
            accentColor: Colors.deepOrange,
            colorScheme: ColorScheme(
              background: DeepBlue.kToDark,
              onBackground: Colors.white,
              brightness: Brightness.dark,
              primaryVariant: DeepBlue.kToDark,
              primary: DeepBlue.kToDark,
              secondaryVariant: Colors.deepOrange,
              secondary: Colors.deepOrange,
              surface: Colors.white,
              onSurface: Colors.white,
              error: Colors.red,
              onError: Colors.red,
              onPrimary: DeepBlue.kToDark,
              onSecondary: Colors.deepOrange,
            ),
            fontFamily: 'Lato',
            iconTheme: IconThemeData(
              color: Colors.deepOrange,
            ),
            appBarTheme: AppBarTheme(
              backgroundColor: DeepBlue.kToDark,
            ),
          ),
          themeMode: Provider.of<Light>(ctx).themeDark
              ? ThemeMode.dark
              : ThemeMode.light,
          debugShowCheckedModeBanner: false,
        ),
      ),
    );
  }
}
