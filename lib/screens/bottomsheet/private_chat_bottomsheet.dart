import 'package:daakia_vc_flutter_sdk/screens/customWidget/initials_circle.dart';
import 'package:flutter/material.dart';

import '../../utils/utils.dart';
import '../../viewmodel/rtc_viewmodel.dart';
import '../customWidget/message_bubble.dart';

class PrivateChatBottomSheet extends StatefulWidget {
  PrivateChatBottomSheet(
      {required this.viewModel, this.identity = "", this.name = "", super.key});

  final String identity;
  final String name;
  final RtcViewmodel viewModel;

  final TextEditingController messageController = TextEditingController();

  @override
  State<StatefulWidget> createState() {
    return PrivateChantState();
  }
}

class PrivateChantState extends State<PrivateChatBottomSheet> {
  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        if (widget.identity.isEmpty &&
            widget.viewModel.getPrivateMessage().isNotEmpty) {
          var privateMessages =
              widget.viewModel.getPrivateMessage().values.toList();
          var person = privateMessages[0];
          widget.viewModel.setPrivateChatIdentity(person.identity);
          widget.viewModel.setPrivateChatUserName(person.name);
        } else {
          widget.viewModel.setPrivateChatIdentity(widget.identity);
          widget.viewModel.setPrivateChatUserName(widget.name);
        }
      });
    });
  }

  final TextEditingController messageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return PopScope(
      child: Scaffold(
        backgroundColor: const Color(0xFF000000),
        // Use a specific color for no_video_background
        body: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20.0),
          child: Column(children: [
            Visibility(
                visible: (widget.viewModel.getPrivateMessage().isEmpty),
                child: const Center(
                  child: Text(
                    "No private chat available!",
                    style: TextStyle(
                      color: Colors.white, // Adjust text color
                      fontSize: 16.0, // Adjust font size
                    ),
                  ),
                )),
            Visibility(
              visible: (widget.viewModel.getPrivateMessage().isNotEmpty),
              child: Expanded(
                child: Column(
                  children: [
                    SizedBox(
                      height: 80.0, // Set a fixed height for the ListView
                      child: ListView.builder(
                        itemCount: widget.viewModel.getPrivateMessage().length,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) {
                          // Convert the map to a list of PrivateChatModel
                          var privateMessages = widget.viewModel
                              .getPrivateMessage()
                              .values
                              .toList();
                          var person = privateMessages[
                              index]; // Get the item at the current index
                          return Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  widget.viewModel
                                      .setPrivateChatIdentity(person.identity);
                                  widget.viewModel
                                      .setPrivateChatUserName(person.name);
                                });
                              },
                              child: Center(
                                // Center the Column
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  // Make the Column size itself based on its content
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  // Center the child widgets horizontally
                                  children: [
                                    InitialsCircle(
                                      initials: Utils.getInitials(person.name),
                                      isSelected: (person.identity ==
                                          widget.viewModel
                                              .getPrivateChatIdentity()),
                                    ),
                                    Text(
                                      person.name,
                                      style: TextStyle(
                                          color: (person.identity ==
                                                  widget.viewModel
                                                      .getPrivateChatIdentity())
                                              ? Colors.deepPurpleAccent
                                              : Colors.white),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    Text(
                      "ℹ️ You are in ${widget.viewModel.getPrivateChatUserName()}'s private chat window.",
                      // Using Unicode info symbol
                      style: const TextStyle(
                        color: Colors.white, // Adjust text color
                        fontSize: 16.0, // Adjust font size
                      ),
                    ),
                    Expanded(
                      child: ListView.builder(
                        reverse: true,
                        itemCount: widget.viewModel
                            .getPrivateChatForParticipant(
                                widget.viewModel.getPrivateChatIdentity())
                            .length, // Placeholder item count
                        itemBuilder: (context, index) {
                          final reversedIndex = widget.viewModel
                                  .getPrivateChatForParticipant(
                                      widget.viewModel.getPrivateChatIdentity())
                                  .length -
                              1 -
                              index;
                          var message = widget.viewModel
                              .getPrivateChatForParticipant(widget.viewModel
                                  .getPrivateChatIdentity())[reversedIndex];
                          return MessageBubble(
                              userName: message.identity?.name ?? "Unknown",
                              message: message.message ?? "",
                              time: Utils.formatTimestampToTime(
                                  message.timestamp),
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
                              setState(() {
                                if (messageController.text.isEmpty) return;
                                widget.viewModel.sendPrivateMessage(
                                    widget.viewModel.getPrivateChatIdentity(),
                                    widget.viewModel.getPrivateChatUserName(),
                                    messageController.text);
                                messageController.clear();
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
