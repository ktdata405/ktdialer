import 'package:flutter/material.dart';

class CommonMethods {
  static void showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  static String formatPhoneNumber(String number) {
    // Basic formatting logic
    return number.replaceAll(RegExp(r'\s+'), '');
  }
}
