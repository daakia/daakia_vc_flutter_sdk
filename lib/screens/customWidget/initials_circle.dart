import 'package:flutter/material.dart';

class InitialsCircle extends StatelessWidget {
  final String initials;
  final Color backgroundColor;
  final double size;
  final TextStyle textStyle;
  final bool isSelected;

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
    this.isSelected = false, // Add a parameter to indicate selection
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size + 4, // Add extra space for the border
      height: size + 4,
      padding: const EdgeInsets.all(2.0), // Add padding for the border effect
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: isSelected
            ? Border.all(color: Colors.deepPurpleAccent, width: 2.0)
            : null, // Add border only if selected
      ),
      child: Container(
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
      ),
    );
  }
}

