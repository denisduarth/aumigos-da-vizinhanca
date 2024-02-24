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
        content: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Container(
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(20)),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      isError
                          ? const Icon(
                              Icons.warning,
                              color: Colors.white,
                            )
                          : const Icon(
                              Icons.verified_user,
                              color: Colors.white,
                            ),
                    ],
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
        duration: const Duration(seconds: 2),
        margin: const EdgeInsetsDirectional.all(20),
        padding: const EdgeInsetsDirectional.all(7),
        behavior: SnackBarBehavior.floating,
        clipBehavior: Clip.antiAlias,
        backgroundColor: isError ? Colors.red : Colors.green,
      ),
    );
  }
}
