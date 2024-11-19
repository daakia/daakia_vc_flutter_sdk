import 'package:animated_emoji/emoji.dart';
import 'package:animated_emoji/emojis.g.dart';
import 'package:flutter/material.dart';

import '../../model/emoji_message.dart';

class ReactionBubble extends StatelessWidget{
  const ReactionBubble(this.emojiMessage, {super.key});
  final EmojiMessage? emojiMessage;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Text(emojiMessage?.senderName ?? "Unknown", style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.blueAccent)),
          const SizedBox(height: 2),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              color: Colors.blueAccent.withOpacity(0.7),
            ),
            padding: const EdgeInsets.all(10),
            child: AnimatedEmoji(emojiMessage?.emoji ?? AnimatedEmojis.alarmClock),
          ),
        ],
      ),
    );
  }

}