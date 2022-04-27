import 'package:animated_theme_switcher/animated_theme_switcher.dart';
import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/providers/auth.dart';
import 'package:flutter_complete_guide/providers/light.dart';
import 'package:flutter_complete_guide/providers/users.dart';
import 'package:flutter_complete_guide/screens/cart_screen.dart';
import 'package:flutter_complete_guide/screens/categories_screen.dart';
import 'package:flutter_complete_guide/screens/orders_screen.dart';
import 'package:flutter_complete_guide/widgets/circular_menu.dart';
import 'package:liquid_swipe/liquid_swipe.dart';
import 'package:provider/provider.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';

class LiquidAppSwitchScreen extends StatefulWidget {
  static const routeName = '/liquid-app-switch';
  @override
  _LiquidAppSwitchScreenState createState() => _LiquidAppSwitchScreenState();
}

class _LiquidAppSwitchScreenState extends State<LiquidAppSwitchScreen> {
  var _isInit = true;
  final forwardPages = [
    Container(child: CategoriesScreen()),
    Container(child: CartScreen()),
    Container(child: OrdersScreen()),
  ];

  @override
  void didChangeDependencies() async {
    // TODO: implement didChangeDependencies
    if (_isInit) {
      String auth = Provider.of<Auth>(context, listen: false).token;
      String uid = Provider.of<Auth>(context, listen: false).userId;
      final List args = ModalRoute.of(context).settings.arguments ?? [];
      String _email = args.length != 0 ? args[0] : '';
      bool _isSeller = args.length != 0 ? args[1] : false;
      print('EMAIL | Seller | uid => $_email | $_isSeller | $uid');
      await Provider.of<Users>(context, listen: false)
          .addUser(_email, _isSeller);
    }
    _isInit = false;
    super.didChangeDependencies();
  }

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
            EvaIcons.chevronLeft,
            color: isDark ? Colors.deepOrange : Colors.red,
            size: 40,
          ),
        ),
      ),
    );
  }
}
