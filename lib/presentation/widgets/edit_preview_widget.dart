import 'package:flutter/material.dart';

class EditPreviewWidget extends StatelessWidget {
  final String originalMessage;
  final VoidCallback onCancel;

  const EditPreviewWidget({
    super.key,
    required this.originalMessage,
    required this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.grey[850],
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Left blue vertical bar
          Container(
            width: 4,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.blueAccent,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: 10),
          // Edit preview content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Editing Message",
                  style: TextStyle(
                    color: Colors.blueAccent,
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  originalMessage,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 12.5,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          // Close icon
          GestureDetector(
            onTap: onCancel,
            child: const Padding(
              padding: EdgeInsets.all(4.0),
              child: Icon(Icons.close, color: Colors.white54, size: 18),
            ),
          ),
        ],
      ),
    );
  }
}
