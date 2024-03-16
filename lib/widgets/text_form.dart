// ignore_for_file: must_be_immutable

import '../exports/widgets.dart';
import 'package:flutter/material.dart';

const textFieldStyle = TextStyle(
  fontFamily: 'Poppins',
  fontWeight: FontWeight.w600,
  fontSize: 11.25,
);

const labelStyle = TextStyle(
  color: ComponentColors.mainGray,
  fontFamily: "Poppins",
  fontSize: 11.25,
  fontWeight: FontWeight.w500,
);

final mainBorder = OutlineInputBorder(
  borderRadius: BorderRadius.circular(10),
  borderSide: const BorderSide(
    style: BorderStyle.solid,
    color: ComponentColors.superLightGray,
    strokeAlign: 0,
    width: 1.8,
  ),
);

final focusedBorder = OutlineInputBorder(
  borderRadius: BorderRadius.circular(10),
  borderSide: const BorderSide(
    style: BorderStyle.solid,
    color: ComponentColors.mainYellow,
    strokeAlign: 0,
    width: 2,
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
  String? topText;

  TextForm({
    super.key,
    required this.labelText,
    required this.controller,
    required this.icon,
    required this.obscureText,
    required this.keyboardType,
    required this.validator,
    required this.topText,
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                child: Text(
                  widget.topText!,
                  style: const TextStyle(
                      fontFamily: "Poppins",
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: Colors.black45),
                )),
            const SizedBox(
              height: 10,
            ),
            TextFormField(
              keyboardType: widget.keyboardType,
              decoration: InputDecoration(
                  labelText: widget.labelText,
                  labelStyle: labelStyle,
                  prefixIcon: widget.icon,
                  prefixIconColor: ComponentColors.mainGray,
                  prefixIconConstraints: const BoxConstraints(minWidth: 60),
                  suffixIcon:
                      widget.keyboardType == TextInputType.visiblePassword
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
                                color: ComponentColors.mainGray,
                              ),
                            )
                          : null,
                  suffixIconConstraints: const BoxConstraints(minWidth: 70),
                  focusColor: ComponentColors.lightGray,
                  border: mainBorder,
                  enabledBorder: mainBorder,
                  focusedBorder: focusedBorder,
                  fillColor: Colors.white,
                  filled: true,
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 20,
                  ),
                  floatingLabelBehavior: FloatingLabelBehavior.never),
              controller: widget.controller,
              obscureText: widget.obscureText,
              style: textFieldStyle,
              validator: widget.validator,
            ),
          ],
        ));
  }
}
