import 'package:daakia_vc_flutter_sdk/screens/customWidget/message_bubble.dart';
import 'package:daakia_vc_flutter_sdk/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../viewmodel/livekit_viewmodel.dart';

class ChatBottomSheet extends StatefulWidget {
  const ChatBottomSheet({super.key});

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
      final viewModel = Provider.of<LivekitViewmodel>(context, listen: false);
      viewModel.isChatOpen = true;
      viewModel.resetUnreadCount();
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<LivekitViewmodel>(context);
    final TextEditingController messageController = TextEditingController();

    return PopScope(
      onPopInvokedWithResult: (isPoped, dynamic) async {
        viewModel.isChatOpen = false;
      },
      child: Scaffold(
        backgroundColor: const Color(0xFF000000),
        // Use a specific color for no_video_background
        body: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20.0),
          child: Column(
            children: [
              // Toolbar
              Padding(
                padding: const EdgeInsets.only(top: 10.0, bottom: 20.0),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back),
                      color: Colors.white,
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                    const SizedBox(width: 20.0),
                    const Expanded(
                      child: Text(
                        "Chats",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),

              // RecyclerView (use ListView in Flutter)
              Expanded(
                child: ListView.builder(
                  reverse: true,
                  itemCount: viewModel
                      .getMessageList()
                      .length, // Placeholder item count
                  itemBuilder: (context, index) {
                    final reversedIndex =
                        viewModel.getMessageList().length - 1 - index;
                    var message = viewModel.getMessageList()[reversedIndex];
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
                        viewModel.sendData(messageController.text);
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
}
