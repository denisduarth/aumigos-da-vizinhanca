// ignore_for_file: file_names

import 'package:flutter/material.dart';

final labelStyle = TextStyle(
  color: Colors.grey[200],
  fontFamily: "Poppins",
  fontSize: 12,
  fontWeight: FontWeight.w500,
);

const textFieldStyle = TextStyle(
  fontFamily: 'Poppins',
  fontWeight: FontWeight.w500,
  fontSize: 12,
);

class TextForm extends StatelessWidget {
  final String? labelText;
  final TextEditingController? controller;
  final Icon? icon;
  final bool obscureText;
  final TextInputType keyboardType;

  const TextForm({
    super.key,
    required this.labelText,
    required this.controller,
    required this.icon,
    required this.obscureText,
    required this.keyboardType,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width - 60,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(7)),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            offset: Offset(0, 5),
            blurRadius: 10,
            spreadRadius: 5,
          ),
        ],
      ),
      child: Column(
        children: [
          TextField(
            cursorRadius: const Radius.circular(7),
            keyboardType: keyboardType,
            textAlignVertical: TextAlignVertical.center,
            decoration: InputDecoration(
              labelText: labelText,
              labelStyle: labelStyle,
              prefixIcon: icon,
              prefixIconColor: Colors.grey[200],
              border: InputBorder.none,
            ),
            controller: controller,
            obscureText: obscureText,
            style: textFieldStyle,
          ),
        ],
      ),
    );
  }
}
