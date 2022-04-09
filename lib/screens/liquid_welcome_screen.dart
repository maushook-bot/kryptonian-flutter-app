import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/screens/auth_screen.dart';
import 'package:flutter_complete_guide/widgets/welcome.dart';
import 'package:liquid_swipe/liquid_swipe.dart';

class LiquidWelcomeScreen extends StatefulWidget {
  @override
  State<LiquidWelcomeScreen> createState() => _LiquidWelcomeScreenState();
}

class _LiquidWelcomeScreenState extends State<LiquidWelcomeScreen> {
  final pages = [
    Container(child: Welcome()),
    Container(child: AuthScreen()),
  ];

  @override
  Widget build(BuildContext context) {
    return LiquidSwipe(
      pages: pages,
      enableLoop: true,
      fullTransitionValue: 300,
      enableSlideIcon: true,
      waveType: WaveType.liquidReveal,
      positionSlideIcon: 0.5,
      slideIconWidget: Icon(
        Icons.keyboard_arrow_left,
        color: Colors.deepOrange,
        size: 40,
      ),
    );
  }
}
