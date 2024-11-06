import 'package:flutter/material.dart';

class InitialsCircle extends StatelessWidget {
  final String initials;
  final Color backgroundColor;
  final double size;
  final TextStyle textStyle;

  const InitialsCircle({
    super.key,
    required this.initials,
    this.backgroundColor = const Color(0xFFFD4563),
    this.size = 50.0,
    this.textStyle = const TextStyle(
      color: Colors.white,
      fontWeight: FontWeight.bold,
      fontSize: 15.0,
    ),
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: backgroundColor,
        shape: BoxShape.circle,
      ),
      alignment: Alignment.center,
      child: Text(
        initials,
        style: textStyle,
        maxLines: 1,
      ),
    );
  }
}
