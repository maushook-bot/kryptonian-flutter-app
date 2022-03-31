import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/helpers/custom_route.dart';
import 'package:flutter_complete_guide/pallete/deepBlue.dart';
import 'package:flutter_complete_guide/screens/auth_screen.dart';
import 'package:google_fonts/google_fonts.dart';

class Welcome extends StatelessWidget {
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
                child: Image.asset(
                  'assets/images/asteroid-belt.png',
                  width: 500,
                  height: 180,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.only(
              top: deviceSize.height * 0,
              bottom: deviceSize.height * 0.55,
              right: deviceSize.height * 0,
              left: deviceSize.height * 0,
            ),
            child: Image.asset(
              'assets/images/asteroid-belt-1.png',
              width: 500,
              height: 180,
              fit: BoxFit.cover,
            ),
          ),
          Container(
            padding: EdgeInsets.only(
              top: deviceSize.height * 0,
              bottom: deviceSize.height * 0.15,
              right: deviceSize.height * 0,
              left: deviceSize.height * 0,
            ),
            child: Image.asset(
              'assets/images/Black-Hole.png',
              width: 460,
              height: 420,
              fit: BoxFit.cover,
            ),
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
                    style: GoogleFonts.poppins(
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
                    style: GoogleFonts.poppins(
                        fontSize: 17,
                        color: const Color(0xffBABABA),
                        fontWeight: FontWeight.w300),
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
                          style: GoogleFonts.poppins(
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
}
