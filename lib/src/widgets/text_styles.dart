import 'package:aumigos_da_vizinhanca/src/widgets/colors.dart';
import 'package:flutter/material.dart';

final class TextStyles {
  static TextStyle textStyle({
    required Color fontColor,
    required double fontSize,
    required FontWeight fontWeight,
  }) =>
      TextStyle(
        fontFamily: "Poppins",
        fontSize: fontSize,
        color: fontColor,
        fontWeight: fontWeight,
      );
  
  static TextStyle textStyleWithComponentColor({
    required String stringColor,
    required double fontSize,
    required FontWeight fontWeight,
  }) =>
      TextStyle(
        fontFamily: "Poppins",
        fontSize: fontSize,
        color: switch (stringColor.toLowerCase()) {
          'sweet_brown' => ComponentColors.sweetBrown,
          'main_brown' => ComponentColors.mainBrown,
          'main_black' => ComponentColors.mainBlack,
          'main_yellow' => ComponentColors.mainGray,
          'main_gray' => ComponentColors.mainGray,
          _ => Colors.black
        },
        fontWeight: fontWeight,
      );
}
