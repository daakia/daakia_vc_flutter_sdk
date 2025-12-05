import 'package:flutter/material.dart';

class InitialsCircle extends StatelessWidget {
  final String initials;
  final Color backgroundColor;
  final double size;
  final TextStyle textStyle;
  final bool isSelected;
  final VoidCallback? onEdit;
  final int unreadCount;

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
    this.isSelected = false,
    this.onEdit,
    this.unreadCount = 0,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onEdit,
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: [
          // Main avatar with initials
          Container(
            width: size + 4,
            height: size + 4,
            padding: const EdgeInsets.all(2.0),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: isSelected
                  ? Border.all(color: Colors.deepPurpleAccent, width: 2.0)
                  : null,
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
          ),

          // Edit icon
          if (onEdit != null)
            Positioned(
              bottom: 1,
              right: 1,
              child: Container(
                width: size * 0.3,
                height: size * 0.3,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.edit,
                  size: 12,
                  color: Colors.black54,
                ),
              ),
            ),

          // 👇 Unread badge
          if (unreadCount > 0)
            Positioned(
              top: -2,
              right: -2,
              child: Container(
                padding: const EdgeInsets.all(4),
                constraints: BoxConstraints(
                  minWidth: size * 0.3,
                  minHeight: size * 0.3,
                ),
                decoration: BoxDecoration(
                  color: Colors.redAccent,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 1.5),
                ),
                alignment: Alignment.center,
                child: Text(
                  unreadCount > 99 ? '99+' : unreadCount.toString(),
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: size * 0.18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
