import 'package:daakia_vc_flutter_sdk/events/rtc_events.dart';
import 'package:daakia_vc_flutter_sdk/screens/bottomsheet/chat_bottomsheet.dart';
import 'package:daakia_vc_flutter_sdk/screens/bottomsheet/private_chat_bottomsheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../viewmodel/rtc_viewmodel.dart';

class ChatController extends StatefulWidget {
  const ChatController(
      {required this.viewModel, this.identity = "", this.name = "", super.key});

  final String identity;
  final String name;
  final RtcViewmodel viewModel;

  @override
  State<ChatController> createState() => _ChatControllerState();
}

class _ChatControllerState extends State<ChatController> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    collectLobbyEvents(widget.viewModel);
    SystemChrome.setSystemUIOverlayStyle(
        const SystemUiOverlayStyle(statusBarColor: Colors.black));
    return DefaultTabController(
      initialIndex: widget.identity.isEmpty ? 0 : 1,
      length: 2,
      child: Scaffold(
        backgroundColor: const Color(0xFF000000),
        appBar: AppBar(
          title: const Text(
            "Chats",
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.black,
          iconTheme: const IconThemeData(
            color: Colors.white,
          ),
        ),
        body: Stack(
          children: [
            Column(
              children: [
                const TabBar(
                  indicatorColor: Colors.white,
                  labelColor: Colors.white,
                  unselectedLabelColor: Colors.grey,
                  tabs: [
                    Tab(text: "All Chat"),
                    Tab(text: "Private Chat"),
                  ],
                ),
                Expanded(
                  child: TabBarView(
                    children: [
                      ChatBottomSheet(viewModel: widget.viewModel),
                      PrivateChatBottomSheet(
                        viewModel: widget.viewModel,
                        identity: widget.identity,
                        name: widget.name,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            if (_isLoading)
              AbsorbPointer(
                absorbing: true, // Prevents interactions with the UI
                child: Container(
                  color: Colors.black.withValues(alpha: 0.6),
                  // Semi-transparent overlay
                  child: const Center(
                    child: CircularProgressIndicator(
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    widget.viewModel.cancelMainChatControllerEvent();
    super.dispose();
  }

  bool isEventAdded = false;

  void collectLobbyEvents(RtcViewmodel? viewModel) {
    if (isEventAdded) return;
    isEventAdded = true;
    viewModel?.mainChatController.listen((event) {
      if (event is ShowLoading) {
        if (mounted) {
          setState(() {
            _isLoading = true;
          });
        }
      } else if (event is StopLoading) {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      }
    });
  }
}
