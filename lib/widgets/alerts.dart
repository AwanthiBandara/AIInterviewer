import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';

void showAlert(BuildContext context, String message, Color iconColor) {
  Flushbar(
  message: message,
  icon: Icon(
    Icons.info_outline,
    size: 28.0,
    color: iconColor,
    ),
  flushbarPosition: FlushbarPosition.TOP,
  duration: Duration(seconds: 3),
  leftBarIndicatorColor: iconColor,
)..show(context);
}
