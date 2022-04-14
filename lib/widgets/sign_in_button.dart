import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/widgets/custom_raised_button.dart';

class SignInButton extends CustomRaisedButton {
  SignInButton({
    @required String text,
    Color backgroundColor,
    Color textColor,
    VoidCallback onPressed,
  })  : assert(text != null),
        super(
          child: Text(text),
          backgroundColor: backgroundColor,
          textColor: textColor,
          fontSize: 15.0,
          borderRadius: 4.0,
          height: 40.0,
          onPressed: onPressed,
        );
}
