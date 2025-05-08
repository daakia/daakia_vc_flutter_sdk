import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class AnimatedLogo extends StatelessWidget {
  const AnimatedLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return Animate(
      effects: [ShimmerEffect(duration: 3.seconds)],
      onPlay: (controller) => controller.repeat(), // Infinite shimmer
      child: Container(
        width: 150,
        height: 150,
        // Square shape
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white, // White background behind the logo
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: Colors.blueAccent,
            width: 3,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.2),
              blurRadius: 8,
              offset: const Offset(2, 4),
            ),
          ],
        ),
        child: Image.asset(
          "assets/icons/ic_daakia_logo.png",
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}
