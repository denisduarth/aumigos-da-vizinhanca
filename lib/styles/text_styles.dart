import 'package:aumigos_da_vizinhanca/widgets/all.dart';
import 'package:flutter/material.dart';

const buttonTextStyle = TextStyle(
  fontFamily: "Poppins",
  fontSize: 13,
  fontWeight: FontWeight.w600,
  color: Colors.white,
);

const textFieldStyle = TextStyle(
  fontFamily: 'Poppins',
  fontWeight: FontWeight.w500,
  fontSize: 12,
);

var focusNode = FocusNode();

final labelStyle = TextStyle(
  color: focusNode.hasFocus
      ? ComponentColors.sweetBrown
      : ComponentColors.mainGray,
  fontFamily: "Poppins",
  fontSize: 11.5,
  fontWeight: FontWeight.w500,
);

const hintStyle = TextStyle(
  color: ComponentColors.lightGray,
  fontFamily: "Poppins",
  fontSize: 11.5,
  fontWeight: FontWeight.w500,
);
