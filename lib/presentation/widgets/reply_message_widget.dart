import 'package:daakia_vc_flutter_sdk/model/reply_message.dart';
import 'package:flutter/material.dart';

import '../../utils/utils.dart';
import 'file_type_preview_widget.dart';

class ReplyMessageWidget extends StatelessWidget {
  final ReplyMessage reply;
  final bool isSender;

  const ReplyMessageWidget({
    super.key,
    required this.reply,
    required this.isSender,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 6),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      decoration: BoxDecoration(
        color: isSender
            ? Colors.white.withValues(alpha: 0.15)
            : Colors.white.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(6),
        border: Border(
          left: BorderSide(
            color: isSender ? const Color(0xFFBBDEFB) : Colors.white70,
            width: 3,
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            reply.name,
            style: const TextStyle(
              color: Colors.white70,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 2),
          (Utils.isOnlyLink(reply.message) || Utils.isLink(reply.message))
              ? FileTypePreviewWidget(fileUrl: reply.message)
              : Text(
                  reply.message,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
        ],
      ),
    );
  }
}
