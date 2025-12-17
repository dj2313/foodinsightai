import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

enum ToastType { success, error, info }

class AppToast {
  static void show(
    String message, {
    ToastGravity gravity = ToastGravity.BOTTOM,
    ToastType type = ToastType.info,
  }) {
    Fluttertoast.cancel();

    Color bgColor;
    // Premium color palette
    switch (type) {
      case ToastType.success:
        bgColor = const Color(
          0xFF00C853,
        ).withOpacity(0.95); // Material Green A700
        break;
      case ToastType.error:
        bgColor = const Color(
          0xFFFF3D00,
        ).withOpacity(0.95); // Material Deep Orange A400
        break;
      case ToastType.info:
      default:
        bgColor = const Color(0xFF212121).withOpacity(0.95); // Dark Grey
        break;
    }

    Fluttertoast.showToast(
      msg: message,
      gravity: gravity,
      toastLength: Toast.LENGTH_SHORT,
      backgroundColor: bgColor,
      textColor: Colors.white,
      fontSize: 15, // Slightly larger font
      // Note: fluttertoast doesn't support generic icons/rich text,
      // but modifying colors gives a better semantic cue.
    );
  }
}
