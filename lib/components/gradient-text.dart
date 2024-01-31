// ignore_for_file: file_names

import 'package:aumigos_da_vizinhanca/components/colors.dart';
import 'package:flutter/material.dart';

const gradient = LinearGradient(
  colors: [
    ComponentColors.mainYellow,
    ComponentColors.sweetBrown,
  ],
);

class GradientText extends StatelessWidget {
  final String text;
  final double? textSize;

  const GradientText({
    required this.text,
    required this.textSize,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      blendMode: BlendMode.srcIn,
      shaderCallback: (bounds) => gradient.createShader(
        Rect.fromLTWH(
          0,
          0,
          bounds.width,
          bounds.height,
        ),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: textSize,
          fontFamily: "Poppins",
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }
}
