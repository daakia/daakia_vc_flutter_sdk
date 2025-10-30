import 'package:daakia_vc_flutter_sdk/enum/chat_type_enum.dart';
import 'package:daakia_vc_flutter_sdk/model/remote_activity_data.dart';
import 'package:daakia_vc_flutter_sdk/presentation/widgets/reply_message_widget.dart';
import 'package:daakia_vc_flutter_sdk/viewmodel/rtc_viewmodel.dart';
import 'package:flutter/material.dart';

import '../../utils/utils.dart';
import '../bottom_sheets/message_action_sheet.dart';
import 'file_preview.dart';

class MessageBubble extends StatefulWidget {
  final RemoteActivityData chat;
  final RtcViewmodel viewModel;
  final bool isPrivateChat;

  const MessageBubble({
    super.key,
    required this.chat,
    required this.viewModel,
    this.isPrivateChat = false,
  });

  @override
  State<MessageBubble> createState() => _MessageBubbleState();
}

class _MessageBubbleState extends State<MessageBubble> {
  @override
  Widget build(BuildContext context) {
    final String userName = widget.chat.identity?.name ?? "Unknown";
    final String message = widget.chat.message ?? "";
    final String time = Utils.formatTimestampToTime(widget.chat.timestamp);
    final bool isSender = widget.chat.isSender;
    return Align(
      alignment: isSender ? Alignment.centerRight : Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
        child: Column(
          crossAxisAlignment:
              isSender ? CrossAxisAlignment.end : CrossAxisAlignment.start,
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
            GestureDetector(
              onLongPress: () => !widget.chat.isDeleted
                  ? showModalBottomSheet(
                      context: context,
                      backgroundColor: Colors.transparent,
                      builder: (_) => MessageActionSheet(
                        isMine: isSender,
                        isPinned: Utils.isPinned(
                            widget.chat,
                            widget.isPrivateChat
                                ? widget.viewModel.pinnedPrivateChat
                                : widget.viewModel.pinnedPublicChat),
                        onReply: () {
                          widget.isPrivateChat
                              ? null
                              : (widget.viewModel.publicReplyDraft =
                                  Utils.getReplyDraft(widget.chat,
                                      name: isSender
                                          ? widget.viewModel.room
                                              .localParticipant?.name
                                          : null));
                        },
                        onCopy: () => (),
                        onDelete: () {
                          final chatType = widget.isPrivateChat
                              ? ChatType.private.name
                              : ChatType.public.name;
                          widget.viewModel.deleteMessage(chatType,
                              widget.chat.id, widget.chat.userIdentity);
                          widget.viewModel
                              .sendDeleteMessageAction(chatType, widget.chat);
                        },
                        onPin: () {
                          if (Utils.isPinned(
                              widget.chat,
                              widget.isPrivateChat
                                  ? widget.viewModel.pinnedPrivateChat
                                  : widget.viewModel.pinnedPublicChat)) {
                            !widget.isPrivateChat
                                ? widget.viewModel.pinnedPublicChat = null
                                : widget.viewModel.pinnedPrivateChat = null;
                          } else {
                            !widget.isPrivateChat
                                ? widget.viewModel.pinnedPublicChat =
                                    widget.chat
                                : widget.viewModel.pinnedPrivateChat =
                                    widget.chat;
                          }
                        },
                        onReact: (emoji) => (),
                      ),
                    )
                  : null,
              child: Card(
                color: isSender
                    ? const Color(0xFF2196F3)
                    : const Color(0xFF303030),
                // Different colors for sender and receiver
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: ConstrainedBox(
                  constraints:
                      const BoxConstraints(maxWidth: 200, minWidth: 100),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10.0, vertical: 5.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // ✅ Reply message shown inside the bubble
                        if (widget.chat.replyMessage != null)
                          ReplyMessageWidget(
                            reply: widget.chat.replyMessage!,
                            isSender: isSender,
                          ),

                        // Main message content
                        if (Utils.isOnlyLink(message) || Utils.isLink(message))
                          Center(
                            child: Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              elevation: 0,
                              shadowColor: Colors.transparent,
                              color: Colors.transparent,
                              child: FilePreviewWidget(fileUrl: message),
                            ),
                          )
                        else
                          Text(
                            Utils.extractNonLinkText(message),
                            style: const TextStyle(color: Colors.white),
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
            ),
          ],
        ),
      ),
    );
  }
}
