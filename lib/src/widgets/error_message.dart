// ignore_for_file: file_names

import 'package:flutter/material.dart';

class ErrorMessage {
  final String? message;
  const ErrorMessage({required this.message});

  showErrorMessage(BuildContext context){
    return ScaffoldMessenger.
    of(context).
    showSnackBar(
      SnackBar(
      clipBehavior: Clip.antiAlias,
      duration: const Duration(seconds: 1),
      margin: const EdgeInsets.all(20),
      content: Text(message!),
      backgroundColor: Colors.red.shade300,
    ));
  }
  
}
