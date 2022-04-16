/// @@@ Kryptonian Shop APP @@@
/// @@@ version: 5.2-beta @@@
/// @@@ App Features: Google Sign-in beta ✨
/// @@@ WebServer: FireBase @@@
/// @@@ AUTHOR: Maushook @@@
/// @@@ COPYRIGHT: Neural Bots Inc @@@

import 'package:animated_theme_switcher/animated_theme_switcher.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_complete_guide/providers/auth.dart';
import 'package:flutter_complete_guide/providers/cart.dart';
import 'package:flutter_complete_guide/providers/categories.dart';
import 'package:flutter_complete_guide/providers/light.dart';
import 'package:flutter_complete_guide/providers/orders.dart';
import 'package:flutter_complete_guide/providers/products.dart';
import 'package:flutter_complete_guide/providers/users.dart';
import 'package:flutter_complete_guide/screens/auth_screen.dart';
import 'package:flutter_complete_guide/screens/cart_screen.dart';
import 'package:flutter_complete_guide/screens/categories_screen.dart';
import 'package:flutter_complete_guide/screens/edit_product_screen.dart';
import 'package:flutter_complete_guide/screens/liquid_app_switch_screen.dart';
import 'package:flutter_complete_guide/screens/liquid_welcome_screen.dart';
import 'package:flutter_complete_guide/screens/orders_screen.dart';
import 'package:flutter_complete_guide/screens/product_details_screen.dart';
import 'package:flutter_complete_guide/screens/products_overview_screen.dart';
import 'package:flutter_complete_guide/screens/my_splash_screen.dart';
import 'package:flutter_complete_guide/screens/user_products_screen.dart';
import 'package:flutter_complete_guide/widgets/welcome.dart';
import 'package:provider/provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'data/category_dummy_data.dart';
import 'helpers/theme_config.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await dotenv.load(fileName: "assets/.env");
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var brightness = SchedulerBinding.instance.window.platformBrightness;
    final initTheme = brightness == Brightness.dark ? nightTheme : dayTheme;

    return MultiProvider(
      providers: [
        /// ChangeNotifierProvider Builder with Initialised Objects Products
        /// Anywhere below the child of the Providers, you can listen to the
        /// provided values using Provider.of<Products>(content)
        /// OR Using Consumer<Products>()
        ChangeNotifierProvider(create: (ctx) => Auth()),
        ChangeNotifierProxyProvider<Auth, Users>(
          create: (ctx) => Users('', '', []),
          update: (ctx, auth, previousUsers) => Users(
            auth.token,
            auth.userId,
            previousUsers == null ? [] : previousUsers.usersList,
          ),
        ),
        ChangeNotifierProxyProvider<Auth, Products>(
          create: (ctx) => Products('', '', []),
          update: (ctx, auth, previousProducts) => Products(
            auth.token,
            auth.userId,
            previousProducts == null ? [] : previousProducts.item,
          ),
        ),
        ChangeNotifierProxyProvider<Auth, Categories>(
          create: (ctx) => Categories('', []),
          update: (ctx, auth, previousCategories) => Categories(
            auth.token,
            previousCategories == null ? [] : previousCategories.categories,
          ),
        ),
        ChangeNotifierProvider(create: (ctx) => Cart()),
        ChangeNotifierProvider(create: (ctx) => Light()),
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
        builder: (ctx, authData, _) {
          print('BUILD => MAIN');
          return ThemeProvider(
            initTheme: dayTheme,
            builder: (_, myTheme) => MaterialApp(
              title: 'Krypton',
              theme: myTheme,
              //home: authData.isAuth == true ? ProductsOverviewScreen() : Welcome(),
              routes: {
                '/': (ctx) => authData.isAuth
                    ? CategoriesScreen()
                    : FutureBuilder(
                        future: authData.tryAutoLogin(),
                        builder: (context, snapshot) =>
                            snapshot.connectionState == ConnectionState.waiting
                                ? MySplashScreen()
                                : LiquidWelcomeScreen(),
                      ),
                //LiquidAppSwitchScreen.routeName: (ctx) => LiquidAppSwitchScreen(),
                CategoriesScreen.routeName: (ctx) => CategoriesScreen(),
                AuthScreen.routeName: (ctx) => AuthScreen(),
                ProductsOverviewScreen.routeName: (ctx) =>
                    ProductsOverviewScreen(),
                ProductDetailsScreen.routeName: (ctx) => ProductDetailsScreen(),
                CartScreen.routeName: (ctx) => CartScreen(),
                OrdersScreen.routeName: (ctx) => OrdersScreen(),
                UserProductsScreen.routeName: (ctx) => UserProductsScreen(),
                EditProductScreen.routeName: (ctx) => EditProductScreen(),
              },
              debugShowCheckedModeBanner: false,
            ),
          );
        },
      ),
    );
  }
}
