import 'package:flutter/material.dart';

class LicenseExpiredScreen extends StatelessWidget{
  final String text;

  const LicenseExpiredScreen(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.warning_amber, color: Colors.redAccent, size: 40), // Icon size 24
            const SizedBox(height: 10), // Space between icon and text
            Text(
              text,
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

}