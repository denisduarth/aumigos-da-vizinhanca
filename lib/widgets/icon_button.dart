import 'package:flutter/material.dart';

class IconButtonWidget extends StatelessWidget {
  final Icon icon;
  final Color color;
  final void Function() onPressed;
  final bool enableBorderSide;

  const IconButtonWidget({
    super.key,
    required this.icon,
    required this.onPressed,
    required this.enableBorderSide,
    required this.color,
  });

  final borderSide = const BorderSide(
    color: Colors.white,
    width: 4.0,
    strokeAlign: 0,
  );

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onPressed,
      color: Colors.white,
      icon: icon,
      style: IconButton.styleFrom(
        backgroundColor: color,
        side: enableBorderSide ? borderSide : BorderSide.none,
      ),
    );
  }
}
