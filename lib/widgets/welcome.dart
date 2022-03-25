import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/providers/auth.dart';
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
          )),
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
                    onPressed: () =>
                        Navigator.of(context).pushNamed(AuthScreen.routeName),
                    style: ElevatedButton.styleFrom(
                        fixedSize: const Size(199, 50),
                        primary: const Color(0xffC65466),
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
