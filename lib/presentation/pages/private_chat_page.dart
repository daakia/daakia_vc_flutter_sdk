import 'dart:io';

import 'package:daakia_vc_flutter_sdk/presentation/widgets/initials_circle.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

import '../../events/rtc_events.dart';
import '../../utils/constants.dart';
import '../../utils/utils.dart';
import '../../viewmodel/rtc_viewmodel.dart';
import '../widgets/compact_file_preview.dart';
import '../widgets/message_bubble.dart';
import '../widgets/pinned_message_widget.dart';

class PrivateChatPage extends StatefulWidget {
  PrivateChatPage(
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

class PrivateChantState extends State<PrivateChatPage> {
  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.viewModel.isPrivateChatOpen = true;
      setState(() {
        if (widget.identity.isEmpty &&
            widget.viewModel.getPrivateMessage().isNotEmpty) {
          var privateMessages =
              widget.viewModel.getPrivateMessage().values.toList();
          var person = privateMessages[0];
          widget.viewModel.setPrivateChatIdentity(person.identity);
          widget.viewModel.setPrivateChatUserName(person.name);
          widget.viewModel.resetUnreadPrivateChatCount(person);
        } else {
          widget.viewModel.setPrivateChatIdentity(widget.identity);
          widget.viewModel.setPrivateChatUserName(widget.name);
          var person = widget.viewModel.getPrivateMessage()[widget.identity];
          if (person == null) return;
          widget.viewModel.resetUnreadPrivateChatCount(person);
        }
      });
    });
  }

  final TextEditingController messageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    collectLobbyEvents(widget.viewModel, context);
    return PopScope(
      onPopInvokedWithResult: (isPoped, dynamic) async {
        widget.viewModel.isPrivateChatOpen = false;
      },
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
                                  widget.viewModel
                                      .resetUnreadPrivateChatCount(person);
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
                                      unreadCount: person.unreadCount,
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
                    if (widget.viewModel.pinnedPrivateChat != null)
                      PinnedMessageWidget(
                        name: widget.viewModel.pinnedPrivateChat?.isSender == true ? widget.viewModel.room.localParticipant?.name : widget.viewModel.pinnedPrivateChat?.identity?.name,
                        message: widget.viewModel.pinnedPrivateChat?.message ?? "",
                        onPinPressed: () {
                          widget.viewModel.pinnedPrivateChat = null;
                        },
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
                              chat: message,
                              viewModel: widget.viewModel,
                              isPrivateChat: true
                          );
                        },
                      ),
                    ),
                    // Message Input Section
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10.0, vertical: 10.0),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10.0, vertical: 5.0),
                        decoration: BoxDecoration(
                          color: Colors.grey[800],
                          // Adjust the background color as needed
                          borderRadius: BorderRadius.circular(30.0),
                          // Rounded corners
                          border: Border.all(
                              color: Colors.white
                                  .withValues(alpha: 0.3)), // Optional border
                        ),
                        child: Row(
                          children: [
                            // Attachment Button
                            IconButton(
                              icon: const Icon(Icons.attach_file),
                              color: Colors.white,
                              onPressed: () async {
                                Utils.hideKeyboard(context);
                                try {
                                  widget.viewModel.sendMainChatControllerEvent(
                                      ShowLoading());
                                  FilePickerResult? result =
                                      await FilePicker.platform.pickFiles(
                                    allowMultiple: false,
                                    type: FileType.custom,
                                    allowedExtensions:
                                        Constant.allowedExtensions(),
                                  );
                                  widget.viewModel.sendMainChatControllerEvent(
                                      StopLoading());
                                  if (result != null) {
                                    File? file =
                                        result.files.single.path != null
                                            ? File(result.files.single.path!)
                                            : null;
                                    var isValidFileSize =
                                        await Utils.validateFile(file, (error) {
                                      widget.viewModel.sendMessageToUI(error);
                                    });
                                    if (!isValidFileSize) {
                                      return;
                                    }
                                    if (file != null) {
                                      if (!context.mounted) return;
                                      showModalBottomSheet(
                                        context: context,
                                        builder: (context) => Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              const Text(
                                                "Selected File",
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              const SizedBox(height: 10),
                                              LocalFilePreview(
                                                  file: file,
                                                  progress: widget.viewModel
                                                      .privateMessageProgress,
                                                  viewModel: widget.viewModel),
                                              const SizedBox(height: 10),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                // Center the buttons
                                                children: [
                                                  // Delete button
                                                  Container(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    decoration: BoxDecoration(
                                                      color: Colors.redAccent
                                                          .withValues(
                                                              alpha: 0.5),
                                                      // Button-like background
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8.0),
                                                    ),
                                                    child: IconButton(
                                                      onPressed: () {
                                                        Navigator.pop(context);
                                                      },
                                                      icon: const Icon(
                                                          Icons.delete,
                                                          color:
                                                              Colors.redAccent),
                                                      tooltip: "Delete",
                                                    ),
                                                  ),
                                                  const SizedBox(width: 10),
                                                  // Spacing between buttons
                                                  // Upload button
                                                  Container(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    decoration: BoxDecoration(
                                                      color: Colors.green
                                                          .withValues(
                                                              alpha: 0.5),
                                                      // Button-like background
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8.0),
                                                    ),
                                                    child: IconButton(
                                                      onPressed: () {
                                                        setState(() {
                                                          widget.viewModel
                                                              .uploadPrivateAttachment(
                                                                  widget
                                                                      .viewModel
                                                                      .getPrivateChatIdentity(),
                                                                  widget
                                                                      .viewModel
                                                                      .getPrivateChatUserName(),
                                                                  file, () {
                                                            Navigator.pop(
                                                                context);
                                                          });
                                                        });
                                                      },
                                                      icon: const Icon(
                                                          Icons.upload,
                                                          color: Colors.green),
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
                                      widget.viewModel
                                          .sendMessageToUI("File not found!");
                                    }
                                  } else {
                                    widget.viewModel
                                        .sendMessageToUI("File not selected!");
                                  }
                                } catch (e) {
                                  widget.viewModel.sendMessageToUI(
                                      e.runtimeType.toString());
                                } finally {
                                  widget.viewModel.sendMainChatControllerEvent(
                                      StopLoading());
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
                                  border: InputBorder
                                      .none, // Removes default borders
                                ),
                                style: const TextStyle(color: Colors.white),
                              ),
                            ),

                            // Send button
                            IconButton(
                              icon: const Icon(Icons.send),
                              color: Colors.white,
                              onPressed: () {
                                Utils.hideKeyboard(context);
                                setState(() {
                                  if (messageController.text.trim().isEmpty) return;
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

  bool isEventAdded = false;

  void collectLobbyEvents(RtcViewmodel? viewModel, BuildContext context) {
    if (isEventAdded) return;
    isEventAdded = true;
    viewModel?.privateChatEvents.listen((event) {
      if (event is UpdateView) {
        if (mounted) {
          setState(() {});
        }
      }
    });
  }
}
