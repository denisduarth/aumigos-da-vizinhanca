// ignore_for_file: must_be_immutable

import 'package:aumigos_da_vizinhanca/widgets/all.dart';
import 'package:flutter/material.dart';

const sweetBrownLight = Color.fromARGB(255, 255, 217, 200);

final border = OutlineInputBorder(
  borderRadius: BorderRadius.circular(30),
  borderSide: const BorderSide(
    style: BorderStyle.solid,
    color: sweetBrownLight,
  ),
);

const textFieldStyle = TextStyle(
  fontFamily: 'Poppins',
  fontWeight: FontWeight.w600,
  fontSize: 11,
);

const labelStyle = TextStyle(
  color: sweetBrownLight,
  fontFamily: "Poppins",
  fontSize: 11,
  fontWeight: FontWeight.w600,
);

const hintStyle = TextStyle(
  color: sweetBrownLight,
  fontFamily: "Poppins",
  fontSize: 11,
  fontWeight: FontWeight.w600,
);

final focusedBorder = OutlineInputBorder(
  borderRadius: BorderRadius.circular(30),
  borderSide: const BorderSide(
    width: 3,
    strokeAlign: 0.0,
    style: BorderStyle.solid,
    color: ComponentColors.sweetBrown,
  ),
);

final enabledBorder = OutlineInputBorder(
  borderRadius: BorderRadius.circular(30),
  borderSide: const BorderSide(
    width: 1,
    strokeAlign: 0.0,
    style: BorderStyle.solid,
    color: ComponentColors.sweetBrown,
  ),
);

class TextForm extends StatefulWidget {
  String? labelText;
  String? hintText;
  TextEditingController? controller;
  Icon? icon;
  Widget? suffixIcon;
  bool obscureText;
  TextInputType keyboardType;
  String? Function(String?)? validator;

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
  State<TextForm> createState() => _TextFormState();
}

class _TextFormState extends State<TextForm> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width - 50,
      child: TextFormField(
        keyboardType: widget.keyboardType,
        decoration: InputDecoration(
          alignLabelWithHint: true,
          hintText: widget.hintText,
          hintStyle: hintStyle,
          labelText: widget.labelText,
          labelStyle: labelStyle,
          prefixIcon: widget.icon,
          prefixIconColor: ComponentColors.sweetBrown,
          prefixIconConstraints: const BoxConstraints(minWidth: 60),
          suffixIcon: widget.keyboardType == TextInputType.visiblePassword
              ? IconButton(
                  onPressed: () {
                    setState(() {
                      widget.obscureText = !widget.obscureText;
                    });
                  },
                  icon: Icon(
                    widget.obscureText
                        ? Icons.visibility
                        : Icons.visibility_off,
                    color: ComponentColors.sweetBrown,
                  ),
                )
              : null,
          suffixIconConstraints: const BoxConstraints(minWidth: 60),
          border: focusedBorder,
          enabledBorder: enabledBorder,
          focusColor: ComponentColors.sweetBrown,
          focusedBorder: focusedBorder,
          fillColor: Colors.white,
          filled: true,
          contentPadding: const EdgeInsets.symmetric(
            vertical: 20,
          ),
          floatingLabelStyle: const TextStyle(
            color: ComponentColors.sweetBrown,
            fontWeight: FontWeight.w600,
            fontSize: 13,
          ),
        ),
        controller: widget.controller,
        obscureText: widget.obscureText,
        style: textFieldStyle,
        validator: widget.validator,
      ),
    );
  }
}
