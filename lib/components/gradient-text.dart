// ignore_for_file: file_names

import 'package:aumigos_da_vizinhanca/components/colors.dart';
import 'package:flutter/material.dart';

const style = TextStyle(
  fontSize: 50,
  fontFamily: "Poppins",
  fontWeight: FontWeight.w800,
);

const gradient = LinearGradient(
  colors: [
    ComponentColors.mainYellow,
    ComponentColors.mainBrown,
  ],
);

class GradientText extends StatelessWidget {
  const GradientText({
    required this.text,
    super.key,
  });

  final String text;

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
        style: style,
      ),
    );
  }
}
