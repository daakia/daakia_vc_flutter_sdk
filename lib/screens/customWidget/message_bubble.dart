import 'package:flutter/material.dart';

class MessageBubble extends StatelessWidget {
  final String userName;
  final String message;
  final String time;
  final bool isSender;

  const MessageBubble({
    Key? key,
    required this.userName,
    required this.message,
    required this.time,
    this.isSender = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isSender ? Alignment.centerRight : Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
        child: Column(
          crossAxisAlignment: isSender ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            // Display username for the receiver only
            if (!isSender)
              Text(
                userName,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            if (!isSender) const SizedBox(height: 5.0),

            // Message Card
            Card(
              color: isSender ? const Color(0xFF2196F3) : const Color(0xFF303030), // Different colors for sender and receiver
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 200, minWidth: 100),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Message Text
                      Text(
                        message,
                        style: TextStyle(color: Colors.black),
                      ),
                      const SizedBox(height: 5.0),

                      // Sent Time
                      Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          time,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 8.0,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
