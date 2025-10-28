import 'package:daakia_vc_flutter_sdk/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../resources/colors/color.dart';

class MessageActionSheet extends StatelessWidget {
  final bool isMine;
  final bool isPinned;
  final VoidCallback? onReply;
  final VoidCallback? onCopy;
  final VoidCallback? onPin;
  final VoidCallback? onDelete;
  final Function(String emoji)? onReact;

  const MessageActionSheet({
    super.key,
    this.isMine = false,
    this.isPinned = false,
    this.onReply,
    this.onCopy,
    this.onPin,
    this.onDelete,
    this.onReact,
  });

  static const _reactions = ['❤️', '😂', '😮', '😢', '👍', '👎'];

  @override
  Widget build(BuildContext context) {
    HapticFeedback.selectionClick();

    return SafeArea(
      child: Container(
        margin: const EdgeInsets.all(10),
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
        decoration: BoxDecoration(
          color: emptyVideoColor,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.15),
              blurRadius: 12,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Reaction bar
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: _reactions.map((emoji) {
                return GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                    onReact?.call(emoji);
                    HapticFeedback.lightImpact();
                  },
                  child: AnimatedScale(
                    scale: 1.0,
                    duration: const Duration(milliseconds: 150),
                    child: Text(
                      emoji,
                      style: const TextStyle(fontSize: 28),
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 12),
            const Divider(),
            // Action buttons
            _buildActionRow(context),
          ],
        ),
      ),
    );
  }

  Widget _buildActionRow(BuildContext context) {
    final actions = <_MessageAction>[
      _MessageAction('Reply', Icons.reply, onReply),
      _MessageAction('Copy', Icons.copy, onCopy),
      _MessageAction(isPinned ? 'Unpin' : 'Pin', Icons.push_pin, onPin),
      if (isMine) _MessageAction('Delete', Icons.delete, onDelete),
    ];

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: actions
          .where((a) => a.onTap != null)
          .map((a) => _ActionButton(action: a))
          .toList(),
    );
  }
}

class _MessageAction {
  final String label;
  final IconData icon;
  final VoidCallback? onTap;
  const _MessageAction(this.label, this.icon, this.onTap);
}

class _ActionButton extends StatelessWidget {
  final _MessageAction action;
  const _ActionButton({required this.action});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.selectionClick();
        Navigator.pop(context);
        action.onTap?.call();
        Utils.hideKeyboard(context); // 👈 This line closes the keyboard
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(action.icon, size: 22, color: Colors.white),
          const SizedBox(height: 4),
          Text(
            action.label,
            style: TextStyle(
              color: Colors.white,
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
