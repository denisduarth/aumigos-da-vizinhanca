import 'package:aumigos_da_vizinhanca/src/widgets/colors.dart';
import 'package:flutter/material.dart';

const double paddingValue = 10;

const buttonTextStyle = TextStyle(
  fontFamily: "Poppins",
  fontSize: 13,
  fontWeight: FontWeight.w600,
  color: Colors.white,
);

const textStyle = TextStyle(
  fontFamily: "Poppins",
  fontSize: 15,
  fontWeight: FontWeight.bold,
  color: Colors.white,
);

class Button extends StatelessWidget {
  final Function()? onTap;
  final Widget buttonIcon, buttonWidget;
  final Color buttonColor;

  const Button({
    required this.onTap,
    required this.buttonWidget,
    this.buttonColor = ComponentColors.mainYellow,
    required this.buttonIcon,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ElevatedButton.icon(
          icon: buttonIcon,
          onPressed: onTap,
          style: ElevatedButton.styleFrom(
            shape: ContinuousRectangleBorder(
                borderRadius: BorderRadius.circular(20)),
            fixedSize: Size(MediaQuery.of(context).size.width - 60, 60),
            backgroundColor: buttonColor,
            padding: const EdgeInsets.symmetric(horizontal: 15),
            textStyle: const TextStyle(
              fontFamily: "Poppins",
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          label: buttonWidget),
    );
  }
}
