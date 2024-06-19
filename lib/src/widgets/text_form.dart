// ignore_for_file: must_be_immutable

import 'package:aumigos_da_vizinhanca/src/widgets/colors.dart';
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
    color: ComponentColors.mainBlack,
    strokeAlign: 2,
    width: 2.5,
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
  void Function(String)? onChanged;

  TextForm(
      {super.key,
      required this.labelText,
      required this.controller,
      required this.icon,
      required this.obscureText,
      required this.keyboardType,
      required this.validator,
      this.topText,
      this.suffixIcon,
      this.onChanged});

  @override
  State<TextForm> createState() => _TextFormState();
}

class _TextFormState extends State<TextForm> {
  @override
  Widget build(BuildContext context) {
    return widget.topText != null
        ? SizedBox(
            width: MediaQuery.of(context).size.width - 50,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15.0),
                  child: Text(
                    widget.topText ?? '',
                    style: const TextStyle(
                        fontFamily: "Poppins",
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: Colors.black45),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                TextFormField(
                  onChanged: widget.onChanged,
                  keyboardType: widget.keyboardType,
                  decoration: InputDecoration(
                      labelText: widget.labelText,
                      labelStyle: labelStyle,
                      prefixIcon: widget.icon,
                      prefixIconColor: ComponentColors.mainGray,
                      prefixIconConstraints: const BoxConstraints(minWidth: 60),
                      suffixIcon: widget.keyboardType ==
                              TextInputType.visiblePassword
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
                          : widget.controller!.text.isNotEmpty
                              ? IconButton(
                                  onPressed: () => widget.controller!.clear(),
                                  icon: const Icon(
                                    Icons.clear,
                                    color: ComponentColors.mainGray,
                                  ),
                                )
                              : null,
                      suffixIconConstraints: const BoxConstraints(minWidth: 70),
                      focusColor: ComponentColors.lightGray,
                      border: mainBorder,
                      focusedBorder: focusedBorder,
                      enabledBorder: mainBorder,
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
            ),
          )
        : SizedBox(
            width: MediaQuery.of(context).size.width - 50,
            child: TextFormField(
              onChanged: widget.onChanged,
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
                          : widget.controller!.text.isNotEmpty
                              ? IconButton(
                                  onPressed: () => widget.controller!.clear(),
                                  icon: const Icon(
                                    Icons.clear,
                                    color: ComponentColors.mainGray,
                                  ),
                                )
                              : null,
                  suffixIconConstraints: const BoxConstraints(minWidth: 70),
                  focusColor: ComponentColors.lightGray,
                  border: mainBorder,
                  focusedBorder: focusedBorder,
                  enabledBorder: mainBorder,
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
          );
  }
}
