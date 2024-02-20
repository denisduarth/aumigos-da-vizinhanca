import 'package:aumigos_da_vizinhanca/widgets/colors.dart';
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
  final Widget buttonWidget;

  const Button({
    required this.onTap,
    required this.buttonWidget,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
          width: MediaQuery.of(context).size.width - 60,
          height: 60,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                ComponentColors.mainYellow,
                ComponentColors.sweetBrown,
              ],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
            borderRadius: BorderRadius.all(
              Radius.circular(paddingValue),
            ),
          ),
          child: Center(child: buttonWidget)),
    );
  }
}
