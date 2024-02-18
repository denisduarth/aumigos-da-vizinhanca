// ignore_for_file: must_be_immutable

import 'package:aumigos_da_vizinhanca/widgets/all.dart';
import 'package:flutter/material.dart';
import '../styles/text_styles.dart';

const double textFormPaddingValue = 10;

final mainBorder = OutlineInputBorder(
  borderRadius: BorderRadius.circular(textFormPaddingValue),
  borderSide: const BorderSide(
    style: BorderStyle.solid,
    color: ComponentColors.superLightGray,
    width: 1.7,
  ),
);

final focusedBorder = OutlineInputBorder(
  borderRadius: BorderRadius.circular(textFormPaddingValue),
  borderSide: const BorderSide(
    style: BorderStyle.solid,
    color: ComponentColors.superLightGray,
    width: 1.7,
  ),
);

class TextForm extends StatelessWidget {
  final String? labelText;
  final String? hintText;
  final TextEditingController? controller;
  final Icon? icon;
  Widget? suffixIcon;
  final bool obscureText;
  final TextInputType keyboardType;
  final String? Function(String?)? validator;

  TextForm({
    super.key,
    required this.labelText,
    required this.hintText,
    required this.controller,
    required this.icon,
    required this.obscureText,
    required this.keyboardType,
    required this.validator,
    this.suffixIcon,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width - 60,
      child: TextFormField(
        clipBehavior: Clip.antiAlias,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          isDense: true,
          alignLabelWithHint: true,
          hintText: hintText,
          hintStyle: hintStyle,
          labelText: labelText,
          labelStyle: labelStyle,
          prefixIcon: icon,
          prefixIconColor: ComponentColors.mainYellow,
          suffixIcon: suffixIcon,
          suffixIconColor: ComponentColors.sweetBrown,
          enabledBorder: mainBorder,
          focusedBorder: focusedBorder,
          filled: false,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 25,
            vertical: 25,
          ),
        ),
        controller: controller,
        obscureText: obscureText,
        style: textFieldStyle,
        validator: validator,
      ),
    );
  }
}
