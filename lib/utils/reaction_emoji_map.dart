class ReactionEmojiMap {
  static const emojiReactionList = ['👍', '❤️', '😃', '😢', '🙏', '👎', '😡'];

  static const Map<String, String> emojiCodeToEmoji = {
    '1f44d': '👍', // Thumbs Up
    '1f44e': '👎', // Thumbs Down
    '2764-fe0f': '❤️', // Red Heart
    '1f603': '😃', // Smiling Face
    '1f622': '😢', // Crying Face
    '1f64f': '🙏', // Folded Hands
    '1f621': '😡', // Angry Face
  };

  /// Reverse map (for sending to backend)
  static final Map<String, String> emojiToCode = {
    for (var e in emojiCodeToEmoji.entries) e.value: e.key,
  };
}