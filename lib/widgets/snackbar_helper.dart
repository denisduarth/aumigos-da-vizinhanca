import 'package:flutter/material.dart';

class SnackBarHelper {
  static void showSnackBar(
    BuildContext context,
    String? message,
    bool isError,
  ) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        showCloseIcon: true,
        content: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            isError
                ? const Icon(
                    Icons.error,
                    color: Colors.white,
                  )
                : const Icon(
                    Icons.verified_user,
                    color: Colors.white,
                  ),
            Text(
              " $message",
            ),
          ],
        ),
        duration: const Duration(seconds: 2),
        margin: const EdgeInsets.all(30),
        behavior: SnackBarBehavior.floating,
        clipBehavior: Clip.antiAlias,
        backgroundColor: isError ? Colors.redAccent : Colors.green.shade400,
      ),
    );
  }
}
