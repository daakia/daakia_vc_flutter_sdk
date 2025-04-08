import 'package:flutter/material.dart';

import '../../utils/utils.dart';
import 'file_preview.dart';

class MessageBubble extends StatefulWidget {
  final String userName;
  final String message;
  final String time;
  final bool isSender;

  const MessageBubble({
    super.key,
    required this.userName,
    required this.message,
    required this.time,
    this.isSender = false,
  });

  @override
  State<MessageBubble> createState() => _MessageBubbleState();
}

class _MessageBubbleState extends State<MessageBubble> {
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: widget.isSender ? Alignment.centerRight : Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
        child: Column(
          crossAxisAlignment:
          widget.isSender ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            // Display username for the receiver only
            if (!widget.isSender)
              Text(
                widget.userName,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            if (!widget.isSender) const SizedBox(height: 5.0),

            // Message Card
            GestureDetector(
              child: Card(
                color: widget.isSender
                    ? const Color(0xFF2196F3)
                    : const Color(0xFF303030), // Different colors for sender and receiver
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
                        if(Utils.isOnlyLink(widget.message) || Utils.isLink(widget.message))
                          Center(
                            child: Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12), // Rounded corners
                              ),
                              elevation: 0, // Zero elevation
                              shadowColor: Colors.transparent, // Transparent shadow
                              color: Colors.transparent, // Transparent background
                              child: FilePreviewWidget(fileUrl: (widget.message), // Replace with your widget
                            ),
                          ),
                          ),
                        if(!Utils.isOnlyLink(widget.message) || !Utils.isLink(widget.message))
                          Text(
                            Utils.extractNonLinkText(widget.message),
                            style: const TextStyle(color: Colors.white),
                          ),
                        const SizedBox(height: 5.0),
              
                        // Sent Time
                        Align(
                          alignment: Alignment.centerRight,
                          child: Text(
                            widget.time,
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
            ),
          ],
        ),
      ),
    );
  }
}
