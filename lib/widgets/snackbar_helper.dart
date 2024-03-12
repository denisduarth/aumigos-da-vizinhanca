import 'package:flutter/material.dart';

class SnackBarHelper {
  void showSnackBar({
    required BuildContext context,
    required String? message,
    required Color color,
    required IconData icon,
    required bool top,
  }) {
    var snackBar = SnackBar(
      showCloseIcon: true,
      content: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Icon(
              icon,
              color: Colors.white,
            ),
            Text(
              "$message",
              style: const TextStyle(fontWeight: FontWeight.w800),
              textAlign: TextAlign.center,
              locale: const Locale('pt', 'BR'),
            ),
          ],
        ),
      ),
      dismissDirection: top ? DismissDirection.up : DismissDirection.down,
      duration: const Duration(seconds: 2),
      behavior: SnackBarBehavior.floating,
      clipBehavior: Clip.antiAlias,
      backgroundColor: color,
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void showErrorSnackbar(String? message, BuildContext context) => showSnackBar(
        context: context,
        message: message,
        color: Colors.red,
        icon: Icons.warning_amber,
        top: false,
      );

  void showSucessSnackbar(String? message, BuildContext context) =>
      showSnackBar(
        context: context,
        message: message,
        color: Colors.green,
        icon: Icons.verified_rounded,
        top: false,
      );
}
