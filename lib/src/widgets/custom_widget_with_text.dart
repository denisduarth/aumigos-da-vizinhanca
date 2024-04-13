import 'package:flutter/material.dart';

class CustomWidgetWithText extends StatelessWidget {
  final String? topText;
  final Widget customWidget;

  const CustomWidgetWithText({
    required this.topText,
    required this.customWidget,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 35.0, vertical: 10.0),
          child: Text(
            topText ?? '',
            style: const TextStyle(
                fontFamily: "Poppins",
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: Colors.black45),
          ),
        ),
        customWidget
      ],
    );
  }
}
