import 'package:flutter/material.dart';

class SnackBarHelper {
  static void showSnackBar(BuildContext context, String? message, Color color,
      IconData icon, bool top) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        showCloseIcon: true,
        content: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
            ),
            child: Center(
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
          ),
        ),
        dismissDirection: top ? DismissDirection.up : DismissDirection.down,
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        clipBehavior: Clip.antiAlias,
        backgroundColor: color,
      ),
    );
  }
}
