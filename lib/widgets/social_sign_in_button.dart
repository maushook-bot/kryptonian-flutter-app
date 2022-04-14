import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/widgets/custom_raised_button.dart';

class SocialSignInButton extends CustomRaisedButton {
  SocialSignInButton({
    @required String assetName,
    @required String text,
    Color backgroundColor,
    Color textColor,
    VoidCallback onPressed,
  })  : assert(assetName != null),
        assert(text != null),
        super(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Image.asset(assetName),
            Text(text),
            Opacity(
              opacity: 0.0,
              child: Image.asset(assetName),
            ),
          ],
        ),
        backgroundColor: backgroundColor,
        textColor: textColor,
        fontSize: 15.0,
        borderRadius: 4.0,
        height: 40.0,
        onPressed: onPressed,
      );
}