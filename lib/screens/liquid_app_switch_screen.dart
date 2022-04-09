import 'dart:async';

import 'package:animated_theme_switcher/animated_theme_switcher.dart';
import 'package:fab_circular_menu/fab_circular_menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/helpers/theme_config.dart';
import 'package:flutter_complete_guide/pallete/deepBlue.dart';
import 'package:flutter_complete_guide/providers/light.dart';
import 'package:flutter_complete_guide/screens/cart_screen.dart';
import 'package:flutter_complete_guide/screens/categories_screen.dart';
import 'package:flutter_complete_guide/screens/orders_screen.dart';
import 'package:flutter_complete_guide/screens/user_products_screen.dart';
import 'package:flutter_complete_guide/widgets/circular_menu.dart';
import 'package:flutter_complete_guide/widgets/main_drawer.dart';
import 'package:liquid_swipe/liquid_swipe.dart';
import 'package:provider/provider.dart';

class LiquidAppSwitchScreen extends StatefulWidget {
  static const routeName = '/liquid-app-switch';
  @override
  _LiquidAppSwitchScreenState createState() => _LiquidAppSwitchScreenState();
}

class _LiquidAppSwitchScreenState extends State<LiquidAppSwitchScreen> {
  final forwardPages = [
    Container(child: CategoriesScreen()),
    Container(child: CartScreen()),
    Container(child: OrdersScreen()),
  ];

  @override
  Widget build(BuildContext context) {
    final lightData = Provider.of<Light>(context, listen: false);
    final isDark = lightData.themeDark;
    return ThemeSwitchingArea(
      child: Scaffold(
        floatingActionButton: CircularMenu(),
        body: LiquidSwipe(
          pages: forwardPages,
          enableLoop: true,
          fullTransitionValue: 300,
          enableSlideIcon: true,
          waveType: WaveType.liquidReveal,
          positionSlideIcon: 0.5,
          slideIconWidget: Icon(
            Icons.keyboard_arrow_left,
            color: isDark ? Colors.deepOrange : Colors.red,
            size: 40,
          ),
        ),
      ),
    );
  }
}
