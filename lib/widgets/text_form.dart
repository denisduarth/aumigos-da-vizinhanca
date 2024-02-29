// ignore_for_file: must_be_immutable

import 'package:aumigos_da_vizinhanca/widgets/all.dart';
import 'package:flutter/material.dart';

const double textFormPaddingValue = 10;

final border = OutlineInputBorder(
  borderRadius: BorderRadius.circular(textFormPaddingValue),
  borderSide: const BorderSide(
    style: BorderStyle.none,
  ),
);

const textFieldStyle = TextStyle(
  fontFamily: 'Poppins',
  fontWeight: FontWeight.w400,
  fontSize: 11,
);

const labelStyle = TextStyle(
  color: ComponentColors.mainGray,
  fontFamily: "Poppins",
  fontSize: 11,
  fontWeight: FontWeight.w400,
);

const hintStyle = TextStyle(
  color: ComponentColors.lightGray,
  fontFamily: "Poppins",
  fontSize: 11,
  fontWeight: FontWeight.w400,
);

final focusedBorder = OutlineInputBorder(
  borderRadius: BorderRadius.circular(textFormPaddingValue),
  borderSide: const BorderSide(
    width: 2.3,
    strokeAlign: 0.0,
    style: BorderStyle.solid,
    color: ComponentColors.sweetBrown,
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
    return Container(
      decoration: BoxDecoration(
        boxShadow: const [
          BoxShadow(
            color: ComponentColors.superLightGray,
            offset: Offset(0, 0),
            blurRadius: 10,
            spreadRadius: 3,
          ),
        ],
        borderRadius: BorderRadius.circular(textFormPaddingValue),
      ),
      width: MediaQuery.of(context).size.width - 70,
      child: TextFormField(
        clipBehavior: Clip.antiAlias,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          floatingLabelStyle: const TextStyle(
            fontFamily: "Poppins",
            fontSize: 12.5,
            color: ComponentColors.sweetBrown,
            fontWeight: FontWeight.w600,
          ),
          alignLabelWithHint: true,
          hintText: hintText,
          hintStyle: hintStyle,
          labelText: labelText,
          labelStyle: labelStyle,
          prefixIcon: icon,
          prefixIconColor: ComponentColors.sweetBrown,
          suffixIcon: suffixIcon,
          suffixIconColor: ComponentColors.sweetBrown,
          enabledBorder: border,
          focusColor: ComponentColors.sweetBrown,
          focusedBorder: focusedBorder,
          fillColor: Colors.white,
          filled: true,
          contentPadding: const EdgeInsets.symmetric(
            vertical: 20,
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
