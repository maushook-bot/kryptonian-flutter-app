import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/pallete/purplay.dart';
import 'package:sensors/sensors.dart';

class PerspectiveZoomScreen extends StatefulWidget {
  static const routeName = '/perspective';
  @override
  _PerspectiveZoomScreenState createState() => _PerspectiveZoomScreenState();
}

class _PerspectiveZoomScreenState extends State<PerspectiveZoomScreen> {
  AccelerometerEvent acceleration;
  StreamSubscription<AccelerometerEvent> _streamSubscription;

  double bgMotionSensitivity = 0.3;
  double cartMotionSensitivity = 0.6;

  @override
  void initState() {
    // TODO: implement initState
    _streamSubscription = accelerometerEvents.listen(
      (event) {
        acceleration = event;
      },
    );
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _streamSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.black,
      body: Container(
        height: deviceSize.height,
        width: deviceSize.width,
        child: Center(
          child: Stack(
            children: [
              _buildPositioned(
                padTop: deviceSize.height * 0,
                padBottom: deviceSize.height * 0,
                padRight: deviceSize.width * 0,
                padLeft: deviceSize.width * 0,
                ImageLoc: 'assets/images/874945.jpg',
                imgWidth: deviceSize.width,
                imgHeight: 1820,
              ),
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.black.withOpacity(1.0),
                      Colors.black.withOpacity(1.0),
                      Colors.black.withOpacity(1.0),
                      Colors.black.withOpacity(1.0),
                      Purplay.kToDark.shade800.withOpacity(0.35),
                    ],
                    begin: Alignment.bottomLeft,
                    end: Alignment.topLeft,
                    stops: [0, 0, 0, 0, 1],
                  ),
                ),
              ),
              _buildPositioned(
                padTop: deviceSize.height * 0,
                padBottom: deviceSize.height * 0.095,
                padRight: deviceSize.width * 0,
                padLeft: deviceSize.width * 0,
                ImageLoc: 'assets/images/shopping_1.png',
                imgWidth: 145,
                imgHeight: 145,
              ),
              _buildPositioned(
                padTop: deviceSize.height * 0,
                padBottom: deviceSize.height * 0.45,
                padRight: deviceSize.width * 0.5,
                padLeft: deviceSize.width * 0,
                ImageLoc: 'assets/images/laptop_rotated.png',
                imgWidth: 120,
                imgHeight: 120,
              ),
              _buildPositioned(
                padTop: deviceSize.height * 0.1,
                padBottom: deviceSize.height * 0.37,
                padRight: deviceSize.width * 0.0009,
                padLeft: deviceSize.width * 0.6,
                ImageLoc: 'assets/images/shopping_cart_rotated.png',
                imgWidth: 120,
                imgHeight: 120,
              ),
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.black.withOpacity(1.0),
                      Colors.black.withOpacity(1.0),
                      Colors.black.withOpacity(1.0),
                      Colors.black.withOpacity(1.0),
                      Purplay.kToDark.shade800.withOpacity(0.25),
                    ],
                    begin: Alignment.bottomRight,
                    end: Alignment.centerLeft,
                    stops: [0, 0, 0, 0, 1],
                  ),
                ),
              ),
              _buildPositioned(
                padTop: deviceSize.height * 0.7,
                padBottom: deviceSize.height * 0.09,
                padRight: deviceSize.width * 0.0009,
                padLeft: deviceSize.width * 0.6,
                ImageLoc: 'assets/images/astranaut_1-removebg-preview.png',
                imgWidth: 120,
                imgHeight: 120,
              ),
              _buildPositioned(
                padTop: deviceSize.height * 0.75,
                padBottom: deviceSize.height * 0.07,
                padRight: deviceSize.width * 0.50,
                padLeft: deviceSize.width * 0.000,
                ImageLoc: 'assets/images/asteroids-removebg-preview.png',
                imgWidth: 500,
                imgHeight: 120,
              ),
            ],
          ),
        ),
      ),
    );
  }

  AnimatedPositioned _buildPositioned({
    double padTop,
    double padBottom,
    double padRight,
    double padLeft,
    String ImageLoc,
    double imgWidth,
    double imgHeight,
  }) {
    return AnimatedPositioned(
      child: Align(
        child: Container(
          padding: EdgeInsets.only(
            top: padTop,
            bottom: padBottom,
            right: padRight,
            left: padLeft,
          ),
          child: Image.asset(
            ImageLoc,
            width: imgWidth,
            height: imgHeight,
            fit: BoxFit.cover,
          ),
        ),
      ),
      duration: Duration(milliseconds: 250),
      top: acceleration != null ? acceleration.z * cartMotionSensitivity : 0.0,
      bottom:
          acceleration != null ? acceleration.z * -cartMotionSensitivity : 0.0,
      right:
          acceleration != null ? acceleration.x * -cartMotionSensitivity : 0.0,
      left: acceleration != null ? acceleration.x * cartMotionSensitivity : 0.0,
    );
  }
}
