import 'package:daakia_vc_flutter_sdk/events/rtc_events.dart';
import 'package:daakia_vc_flutter_sdk/presentation/pages/private_chat_page.dart';
import 'package:daakia_vc_flutter_sdk/presentation/widgets/loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../viewmodel/rtc_viewmodel.dart';
import 'chat_page.dart';

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
    collectChatEvents(widget.viewModel);
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(statusBarColor: Colors.black),
    );

    final isPublicChatAllowed =
        widget.viewModel.meetingDetails.features!.isPublicChatAllowed();
    final isPrivateChatAllowed =
        widget.viewModel.meetingDetails.features!.isPrivateChatAllowed();

    final tabs = <Tab>[];
    final views = <Widget>[];

    if (isPublicChatAllowed) {
      tabs.add(const Tab(text: "All Chat"));
      views.add(ChatPage(viewModel: widget.viewModel));
    }
    if (isPrivateChatAllowed) {
      tabs.add(const Tab(text: "Private Chat"));
      views.add(PrivateChatPage(
        viewModel: widget.viewModel,
        identity: widget.identity,
        name: widget.name,
      ));
    }

    if (tabs.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          title: const Text("Chats", style: TextStyle(color: Colors.white)),
          backgroundColor: Colors.black,
          iconTheme: const IconThemeData(color: Colors.white),
        ),
        body: const Center(
          child: Text(
            "Chat is disabled",
            style: TextStyle(color: Colors.white),
          ),
        ),
        backgroundColor: Colors.black,
      );
    }

    return DefaultTabController(
      length: tabs.length,
      initialIndex: (widget.identity.isEmpty || tabs.length == 1) ? 0 : 1,
      child: Scaffold(
        backgroundColor: const Color(0xFF000000),
        appBar: AppBar(
          title: const Text("Chats", style: TextStyle(color: Colors.white)),
          backgroundColor: Colors.black,
          iconTheme: const IconThemeData(color: Colors.white),
          bottom: TabBar(
            indicatorColor: Colors.white,
            labelColor: Colors.white,
            unselectedLabelColor: Colors.grey,
            tabs: tabs,
          ),
        ),
        body: Stack(
          children: [
            TabBarView(children: views),
            if (_isLoading) const CustomLoader(),
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

  void collectChatEvents(RtcViewmodel? viewModel) {
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
