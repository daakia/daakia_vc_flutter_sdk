import 'package:daakia_vc_flutter_sdk/presentation/widgets/reaction_bubble.dart';
import 'package:daakia_vc_flutter_sdk/viewmodel/rtc_viewmodel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../model/emoji_message.dart';

class EmojiReactionWidget extends StatelessWidget {
  const EmojiReactionWidget({this.viewModel, super.key});

  final RtcViewmodel? viewModel;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 100,
      height: 300, // Adjust height for your reactions
      child: ListView.builder(
        reverse: false, // Newest reactions at the bottom
        itemCount: viewModel?.emojiQueue.length ?? 0,
        itemBuilder: (context, index) {
          final emoji = viewModel?.emojiQueue[index];
          return _buildAnimatedReactionTile(emoji);
        },
      ),
    );
  }
}

Widget _buildAnimatedReactionTile(EmojiMessage? emoji) {
  return TweenAnimationBuilder<double>(
      key: ValueKey(emoji?.timestamp),
      tween: Tween<double>(begin: 0, end: 1),
      duration: const Duration(milliseconds: 300),
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(0, 50 * (1 - value)), // Slide in from bottom
            child: child,
          ),
        );
      },
      child: ReactionBubble(emoji));
}
