import 'package:flutter/material.dart';

import '../../model/reaction_model.dart';
import '../../utils/reaction_emoji_map.dart';

class ReactionDetailsSheet extends StatelessWidget {
  final String? emojiCode;
  final List<Reaction> reactions;

  const ReactionDetailsSheet({
    super.key,
    required this.emojiCode,
    required this.reactions,
  });

  @override
  Widget build(BuildContext context) {
    final titleEmoji = emojiCode != null
        ? ReactionEmojiMap.emojiCodeToEmoji[emojiCode] ?? ''
        : 'All';

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Reactions $titleEmoji',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: Colors.white,
            ),
          ),
          const Divider(color: Colors.white24),
          ...reactions.map((r) {
            final emoji =
                ReactionEmojiMap.emojiCodeToEmoji[r.emoji ?? ''] ?? '❓';
            return ListTile(
              leading: Text(emoji, style: const TextStyle(fontSize: 22)),
              title: Text(
                r.name ?? 'Unknown',
                style: const TextStyle(color: Colors.white),
              ),
            );
          }),
        ],
      ),
    );
  }
}
