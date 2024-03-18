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
    return Center(
      child: TextButton(
        onPressed: onTap,
        style: TextButton.styleFrom(
          shape: ContinuousRectangleBorder(
              borderRadius: BorderRadius.circular(20)),
          fixedSize: Size(MediaQuery.of(context).size.width - 60, 60),
          backgroundColor: ComponentColors.mainYellow,
          padding: const EdgeInsets.all(10),
          textStyle: const TextStyle(
            fontFamily: "Poppins",
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        child: buttonWidget,
      ),
    );
  }
}
