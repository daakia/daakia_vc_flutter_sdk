import 'package:animated_emoji/emoji_data.dart';

class EmojiMessage {
  final AnimatedEmojiData? emoji;
  final String senderName;
  final String timestamp; // Optional

  EmojiMessage({required this.emoji, required this.senderName, required this.timestamp});
}
