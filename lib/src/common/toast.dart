import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AppToast {
  static void show(
    String message, {
    ToastGravity gravity = ToastGravity.BOTTOM,
  }) {
    Fluttertoast.cancel();
    Fluttertoast.showToast(
      msg: message,
      gravity: gravity,
      toastLength: Toast.LENGTH_SHORT,
      backgroundColor: Colors.black.withOpacity(0.85),
      textColor: Colors.white,
      fontSize: 14,
    );
  }
}
