import 'package:flutter/material.dart';

class MySplashScreen extends StatefulWidget {
  @override
  State<MySplashScreen> createState() => _MySplashScreenState();
}

class _MySplashScreenState extends State<MySplashScreen> {
  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.black38,
      body: Align(
        child: Container(
          padding: EdgeInsets.only(
            top: deviceSize.height * 0.2,
            bottom: deviceSize.height * 0.0,
            right: deviceSize.height * 0.0,
            left: deviceSize.height * 0.0,
          ),
          child: Image.asset(
            'assets/images/asteroid-belt.png',
            width: 500,
            height: 180,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
