import 'package:daakia_vc_flutter_sdk/screens/customWidget/message_bubble.dart';
import 'package:daakia_vc_flutter_sdk/utils/utils.dart';
import 'package:flutter/material.dart';

import '../../events/rtc_events.dart';
import '../../viewmodel/rtc_viewmodel.dart';

class ChatBottomSheet extends StatefulWidget {
  const ChatBottomSheet({required this.viewModel, super.key});

  final RtcViewmodel viewModel;

  @override
  State<StatefulWidget> createState() {
    return _ChatState();
  }
}

class _ChatState extends State<ChatBottomSheet> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.viewModel.isChatOpen = true;
      widget.viewModel.resetUnreadCount();
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  final TextEditingController messageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    collectLobbyEvents(widget.viewModel, context);
    return PopScope(
      onPopInvokedWithResult: (isPoped, dynamic) async {
        widget.viewModel.isChatOpen = false;
      },
      child: Scaffold(
        backgroundColor: const Color(0xFF000000),
        // Use a specific color for no_video_background
        body: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20.0),
          child: Column(
            children: [
              Expanded(
                child: ListView.builder(
                  reverse: true,
                  itemCount: widget.viewModel
                      .getMessageList()
                      .length, // Placeholder item count
                  itemBuilder: (context, index) {
                    final reversedIndex =
                        widget.viewModel.getMessageList().length - 1 - index;
                    var message =
                        widget.viewModel.getMessageList()[reversedIndex];
                    return MessageBubble(
                        userName: message.identity?.name ?? "Unknown",
                        message: message.message ?? "",
                        time: Utils.formatTimestampToTime(message.timestamp),
                        isSender: message.isSender);
                  },
                ),
              ),

              // Message Input Section
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 10.0, vertical: 20.0),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: messageController,
                        decoration: const InputDecoration(
                          hintText: "Type here...",
                          hintStyle: TextStyle(color: Colors.white),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                          ),
                        ),
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.send),
                      color: Colors.white,
                      onPressed: () {
                        // Add send action here
                        if (messageController.text.isEmpty) return;
                        widget.viewModel
                            .sendPublicMessage(messageController.text);
                        messageController.clear();
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  bool isEventAdded = false;

  void collectLobbyEvents(RtcViewmodel? viewModel, BuildContext context) {
    if (isEventAdded) return;
    isEventAdded = true;
    viewModel?.publicChatEvents.listen((event) {
      if (event is UpdateView) {
        if (mounted) {
          setState(() {});
        }
      }
    });
  }
}
