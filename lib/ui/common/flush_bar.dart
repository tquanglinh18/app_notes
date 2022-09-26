import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';

enum FlushBarType {
  NOTIFICATION,
  SUCCESS,
  ERROR,
  WARNING,
}

class DxFlushBar {
  static void showFlushBar(
      BuildContext context, {
        FlushBarType type = FlushBarType.NOTIFICATION,
        String title = "",
        String message = "",
        int duration = 2,
        FlushbarPosition position = FlushbarPosition.TOP,
      }) {
    Color backgroundColor;
    Icon icon;
    switch (type) {
      case FlushBarType.NOTIFICATION:
        backgroundColor = const Color(0xFF63a026);
        icon = const Icon(Icons.info, color: Colors.white);
        break;

      case FlushBarType.SUCCESS:
        backgroundColor = const Color(0xFF63a026);
        icon = const Icon(Icons.check_circle, color: Colors.white);
        break;

      case FlushBarType.ERROR:
        backgroundColor = const Color(0xFFf64438);
        icon = const Icon(Icons.error, color: Colors.white);
        break;

      case FlushBarType.WARNING:
        backgroundColor = const Color(0xFFedbc38);
        icon = const Icon(Icons.warning, color: Colors.white);
        break;
    }

    Flushbar flushBar = Flushbar(
      isDismissible: true,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      message: message != ""
          ? message
          : title == ""
          ? "Hệ thông lỗi!"
          : title,
      duration: Duration(seconds: duration),
      flushbarPosition: position,
      backgroundColor: backgroundColor,
      icon: icon,
      flushbarStyle: FlushbarStyle.GROUNDED,
    );
    flushBar.show(context);
  }
}
