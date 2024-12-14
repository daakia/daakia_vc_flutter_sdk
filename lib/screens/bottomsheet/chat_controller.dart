import 'package:daakia_vc_flutter_sdk/screens/bottomsheet/chat_bottomsheet.dart';
import 'package:daakia_vc_flutter_sdk/screens/bottomsheet/private_chat_bottomsheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../viewmodel/rtc_viewmodel.dart';

class ChatController extends StatelessWidget {
  const ChatController({required this.viewModel, this.identity = "", this.name = "", super.key});
  final String identity;
  final String name;
  final RtcViewmodel viewModel;
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
        const SystemUiOverlayStyle(statusBarColor: Colors.black));
    return DefaultTabController(
      initialIndex: identity.isEmpty ? 0 : 1,
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
            color:
                Colors.white, // Set the color you want for the back button here
          ),
        ),
        body: Column(
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
                    children: [ChatBottomSheet(viewModel: viewModel,), PrivateChatBottomSheet(viewModel: viewModel, identity: identity, name: name)]))
          ],
        ),
      ),
    );
  }
}
