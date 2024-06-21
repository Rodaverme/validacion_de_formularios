import 'package:flutter/material.dart';

class NotificationsService {
  static late GlobalKey<ScaffoldMessengerState> messengerKey =
      new GlobalKey<ScaffoldMessengerState>();
  static showSanckbar(String message) {
    final snackbar = new SnackBar(
        backgroundColor: Colors.red,
        content: Center(
          child: Text(
            message,
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
        ));

    messengerKey.currentState!.showSnackBar(snackbar);
  }
}
