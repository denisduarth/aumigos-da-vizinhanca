import 'package:aumigos_da_vizinhanca/components/colors.dart';
import 'package:flutter/material.dart';

class Button extends StatelessWidget {
  final Function()? onPressed;
  final String? buttonText;

  const Button({
    required this.onPressed,
    required this.buttonText,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        height: 50,
        width: MediaQuery.of(context).size.width - 60,
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
            Radius.circular(7),
          ),
        ),
        child: Center(
          child: Text(
            "$buttonText",
            style: const TextStyle(
                fontFamily: "Poppins",
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: Colors.white),
          ),
        ),
      ),
    );
  }
}
