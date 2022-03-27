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
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Color(0xff18203d).withOpacity(1),
                      Color(0xff18203d).withOpacity(1),
                      Colors.black.withOpacity(1),
                      Color(0xff232c51),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    stops: [0, 0, 1, 1],
                  ),
                ),
              ),
              _buildPositioned(
                padTop: deviceSize.height * 0.73,
                padBottom: deviceSize.height * 0.07,
                padRight: deviceSize.width * 0.00,
                padLeft: deviceSize.width * 0.000,
                ImageLoc: 'assets/images/asteroid-belt-1.png',
                imgWidth: 500,
                imgHeight: 180,
              ),
              _buildPositioned(
                padTop: deviceSize.height * 0.85,
                padBottom: deviceSize.height * 0.07,
                padRight: deviceSize.width * 0.50,
                padLeft: deviceSize.width * 0.000,
                ImageLoc: 'assets/images/asteroids-removebg-preview.png',
                imgWidth: 500,
                imgHeight: 180,
              ),
              _buildPositioned(
                padTop: deviceSize.height * 0.57,
                padBottom: deviceSize.height * 0.07,
                padRight: deviceSize.width * 0.00,
                padLeft: deviceSize.width * 0.000,
                ImageLoc: 'assets/images/asteroid-belt.png',
                imgWidth: 500,
                imgHeight: 180,
              ),
              _buildPositioned(
                padTop: deviceSize.height * 0.07,
                padBottom: deviceSize.height * 0.67,
                padRight: deviceSize.width * 0.00,
                padLeft: deviceSize.width * 0.000,
                ImageLoc: 'assets/images/asteroid-belt.png',
                imgWidth: 500,
                imgHeight: 180,
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
