import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/helpers/custom_route.dart';
import 'package:flutter_complete_guide/screens/auth_screen.dart';
//import 'package:google_fonts/google_fonts.dart';

class Welcome extends StatefulWidget {
  @override
  State<Welcome> createState() => _WelcomeState();
}

class _WelcomeState extends State<Welcome> with TickerProviderStateMixin {
  AnimationController _controllerBh;
  AnimationController _controllerAst;

  @override
  void initState() {
    // TODO: implement initState
    _controllerBh =
        AnimationController(vsync: this, duration: Duration(minutes: 3))
          ..repeat();
    _controllerAst =
        AnimationController(vsync: this, duration: Duration(minutes: 15))
          ..repeat();
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _controllerBh.dispose();
    _controllerAst.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;

    return Material(
      type: MaterialType.transparency,
      child: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/images/Welcome.png',
              fit: BoxFit.cover,
            ),
          ),
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
          Positioned(
            child: Align(
              child: Container(
                padding: EdgeInsets.only(
                  top: deviceSize.height * 0.2,
                  bottom: deviceSize.height * 0.0,
                  right: deviceSize.height * 0.0,
                  left: deviceSize.height * 0.0,
                ),
                child: _buildBottomAnimatedAsteroid(context, deviceSize),
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.only(
              top: deviceSize.height * 0,
              bottom: deviceSize.height * 0.15,
              right: deviceSize.height * 0,
              left: deviceSize.height * 0,
            ),
            child: _buildAnimatedBlackHole(context, deviceSize),
          ),
          Container(
            padding: EdgeInsets.only(
              top: deviceSize.height * 0,
              bottom: deviceSize.height * 0.15,
              right: deviceSize.height * 0,
              left: deviceSize.height * 0,
            ),
            child: _buildTopAnimatedAsteroid(context, deviceSize),
          ),
          const Center(),
          Container(
            margin: const EdgeInsets.only(left: 25),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: EdgeInsets.only(
                    top: deviceSize.height * 0.61,
                  ),
                  child: Text(
                    'Kryptonian Boutique',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w500,
                      fontSize: 30,
                      color: Colors.white,
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 10),
                  width: 350,
                  child: Text(
                    "A Futuristic Shopping Platform with Unique User Experience. Almost like transcending to Space!",
                    style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 17,
                        color: const Color(0xffBABABA),
                        fontWeight: FontWeight.normal),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(
                    top: 20,
                  ),
                  // color: Colors.green,
                  child: ElevatedButton(
                    onPressed: () => Navigator.of(context).pushReplacement(
                        CustomRoute(builder: (ctx) => AuthScreen())),
                    //Navigator.of(context).pushNamed(AuthScreen.routeName),

                    style: ElevatedButton.styleFrom(
                        fixedSize: const Size(199, 50),
                        //primary: const Color(0xffC65466),
                        primary: Colors.lightBlue.shade600,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18))),
                    child: Row(
                      // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Get started',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 17,
                            color: Colors.white,
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(left: 40),
                          child: const Icon(
                            Icons.arrow_forward_ios,
                            color: Colors.white,
                          ),
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnimatedBlackHole(BuildContext context, Size deviceSize) {
    return AnimatedBuilder(
      animation: _controllerBh,
      builder: (_, ch) {
        return Transform.rotate(
          angle: _controllerBh.value * 2 * pi,
          child: ch,
        );
      },
      child: Image.asset(
        'assets/images/Black-Hole.png',
        width: 460,
        height: 420,
        fit: BoxFit.fill,
      ),
    );
  }

  Widget _buildTopAnimatedAsteroid(BuildContext context, Size deviceSize) {
    return AnimatedBuilder(
      animation: _controllerAst,
      builder: (_, ch) {
        return Transform.rotate(
          angle: -_controllerAst.value * 2 * pi,
          child: ch,
        );
      },
      child: Image.asset(
        'assets/images/asteroid-belt-1.png',
        width: 500,
        height: 180,
        fit: BoxFit.cover,
      ),
    );
  }

  Widget _buildBottomAnimatedAsteroid(BuildContext context, Size deviceSize) {
    return AnimatedBuilder(
      animation: _controllerAst,
      builder: (_, ch) {
        return Transform.rotate(
          angle: _controllerAst.value * 10 * pi,
          child: ch,
        );
      },
      child: Image.asset(
        'assets/images/asteroid-belt.png',
        width: 500,
        height: 180,
        fit: BoxFit.cover,
      ),
    );
  }
}
