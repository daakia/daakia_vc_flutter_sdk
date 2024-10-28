import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LicenseExpiredScreen extends StatelessWidget{
  final String text;

  const LicenseExpiredScreen(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.warning_amber, color: Colors.redAccent, size: 60), // Icon size 24
          const SizedBox(width: 10), // Space between icon and text
          Text(
            text,
            style: const TextStyle(
              color: Colors.grey,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

}