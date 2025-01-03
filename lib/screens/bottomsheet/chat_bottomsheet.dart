import 'dart:io';

import 'package:daakia_vc_flutter_sdk/screens/customWidget/message_bubble.dart';
import 'package:daakia_vc_flutter_sdk/utils/utils.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

import '../../events/rtc_events.dart';
import '../../viewmodel/rtc_viewmodel.dart';
import '../customWidget/compact_file_preview.dart';

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
                padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
                  decoration: BoxDecoration(
                    color: Colors.grey[800], // Adjust the background color as needed
                    borderRadius: BorderRadius.circular(30.0), // Rounded corners
                    border: Border.all(color: Colors.white.withOpacity(0.3)), // Optional border
                  ),
                  child: Row(
                    children: [
                      // Attachment Button
                      IconButton(
                        icon: const Icon(Icons.attach_file),
                        color: Colors.white,
                        onPressed: () async {
                          try {
                            FilePickerResult? result = await FilePicker.platform.pickFiles(allowMultiple: false);

                            if (result != null) {
                              File? file = result.files.single.path != null ? File(result.files.single.path!) : null;
                              if(file != null) {
                                showModalBottomSheet(
                                  context: context,
                                  builder: (context) => Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        const Text(
                                          "Selected File",
                                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                                        ),
                                        const SizedBox(height: 10),
                                        LocalFilePreview(file: file, progress: widget.viewModel.publicMessageProgress),
                                        const SizedBox(height: 10),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.center, // Center the buttons
                                          children: [
                                            // Delete button
                                            Container(
                                              padding: const EdgeInsets.all(8.0),
                                              decoration: BoxDecoration(
                                                color: Colors.redAccent.withOpacity(0.1), // Button-like background
                                                borderRadius: BorderRadius.circular(8.0),
                                              ),
                                              child: IconButton(
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                },
                                                icon: const Icon(Icons.delete, color: Colors.redAccent),
                                                tooltip: "Delete",
                                              ),
                                            ),
                                            const SizedBox(width: 10), // Spacing between buttons
                                            // Upload button
                                            Container(
                                              padding: const EdgeInsets.all(8.0),
                                              decoration: BoxDecoration(
                                                color: Colors.green.withOpacity(0.1), // Button-like background
                                                borderRadius: BorderRadius.circular(8.0),
                                              ),
                                              child: IconButton(
                                                onPressed: () {
                                                  widget.viewModel.uploadAttachment(file, () {
                                                    Navigator.pop(context);
                                                  });
                                                },
                                                icon: const Icon(Icons.upload, color: Colors.green),
                                                tooltip: "Upload",
                                              ),
                                            ),
                                          ],
                                        )

                                      ],
                                    ),
                                  ),
                                  backgroundColor: Colors.black,
                                );
                              } else {
                                widget.viewModel.sendMessageToUI("File not found!");
                              }
                            } else {
                              widget.viewModel.sendMessageToUI("File not selected!");
                            }
                          } catch (e){
                            widget.viewModel.sendMessageToUI(e.runtimeType.toString());
                          }
                        },
                      ),

                      // Message input field
                      Expanded(
                        child: TextField(
                          controller: messageController,
                          decoration: const InputDecoration(
                            hintText: "Type here...",
                            hintStyle: TextStyle(color: Colors.white),
                            border: InputBorder.none, // Removes default borders
                          ),
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),

                      // Send button
                      IconButton(
                        icon: const Icon(Icons.send),
                        color: Colors.white,
                        onPressed: () {
                          if (messageController.text.isEmpty) return;
                          widget.viewModel.sendPublicMessage(messageController.text);
                          messageController.clear();
                        },
                      ),
                    ],
                  ),
                ),
              )

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
