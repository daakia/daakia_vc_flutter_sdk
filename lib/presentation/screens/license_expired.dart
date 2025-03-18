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
            const Icon(Icons.warning_amber, color: Colors.redAccent, size: 40), // Icon
            const SizedBox(height: 10), // Space between icon and text
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20), // Add horizontal padding
              child: Text(
                text,
                textAlign: TextAlign.center, // Center-align the text
                style: const TextStyle(
                  color: Colors.grey,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }


}