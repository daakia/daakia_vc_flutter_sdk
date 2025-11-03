import 'package:flutter/material.dart';

import '../../model/reaction_model.dart';
import '../../utils/reaction_emoji_map.dart';

class ReactionBarWidget extends StatelessWidget {
  final List<Reaction> reactions;
  final Function(String? emojiCode, List<Reaction> reactions)? onTapReaction;

  const ReactionBarWidget({
    super.key,
    required this.reactions,
    this.onTapReaction,
  });

  @override
  Widget build(BuildContext context) {
    if (reactions.isEmpty) return const SizedBox.shrink();

    // Group reactions by emoji code
    final Map<String, List<Reaction>> grouped = {};
    for (var r in reactions) {
      grouped.putIfAbsent(r.emoji ?? '', () => []).add(r);
    }

    final entries = grouped.entries.toList()
      ..sort((a, b) => b.value.length.compareTo(a.value.length));

    const maxVisible = 3;
    final visibleEntries =
        entries.length > maxVisible ? entries.take(maxVisible) : entries;
    final extraCount =
        entries.length > maxVisible ? entries.length - maxVisible : 0;

    return Padding(
      padding: const EdgeInsets.only(left: 4, top: 4),
      child: Wrap(
        spacing: 4,
        runSpacing: 4,
        children: [
          ...visibleEntries.map((entry) {
            final emoji = ReactionEmojiMap.emojiCodeToEmoji[entry.key] ?? '❓';
            final count = entry.value.length;
            return GestureDetector(
              onTap: () => onTapReaction?.call(entry.key, entry.value),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.1), // subtle transparency
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: Colors.white
                        .withValues(alpha: 0.2), // faint border for contrast
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1), // soft shadow glow
                      blurRadius: 12,
                      spreadRadius: 2,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(emoji, style: const TextStyle(fontSize: 14)),
                    const SizedBox(width: 3),
                    Text('$count',
                        style: const TextStyle(
                            fontSize: 10, color: Colors.white70)),
                  ],
                ),
              ),
            );
          }),
          if (extraCount > 0)
            GestureDetector(
              onTap: () => onTapReaction?.call(null, reactions),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.1), // subtle transparency
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: Colors.white
                        .withValues(alpha: 0.2), // faint border for contrast
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1), // soft shadow glow
                      blurRadius: 12,
                      spreadRadius: 2,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Text(
                  '+$extraCount',
                  style: const TextStyle(fontSize: 12, color: Colors.white70),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
