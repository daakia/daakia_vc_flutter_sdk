import 'package:daakia_vc_flutter_sdk/screens/bottomsheet/all_participant_bottomsheet.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../resources/colors/color.dart';

class MoreOptionBottomSheet extends StatefulWidget {
  const MoreOptionBottomSheet({super.key});

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _MoreOptionState();
  }
}

class _MoreOptionState extends State<MoreOptionBottomSheet> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.maxFinite,
      color: emptyVideoColor,
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(bottom: 25.0), // Margin bottom
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top View (like the handle in a bottom sheet)
              Center(
                child: Container(
                  margin: const EdgeInsets.only(top: 10.0, bottom: 30.0),
                  width: 50,
                  height: 5,
                  color: Colors.white,
                ),
              ),
              // Chats Section
              buildOption(context, icon: Icons.message, text: 'Chats',
                  onTap: () {
                Navigator.pop(context);
              }),
              // Recording Section
              buildOption(
                context,
                icon: Icons
                    .fiber_manual_record, // Replace with your recording icon
                text: 'Start Recording',
              ),
              // Host Controls
              buildOption(
                context,
                icon: Icons.security, // Replace with your host control icon
                text: 'Host Control',
              ),
              // Screen Share
              buildOption(
                context,
                icon: Icons.screen_share, // Replace with your screen share icon
                text: 'Start Screen Sharing',
              ),
              // Raise Hand
              buildOption(
                context,
                icon: Icons.pan_tool, // Replace with your raise hand icon
                text: 'Start Raise Hand',
              ),
              // Reaction
              buildOption(
                context,
                icon: Icons.emoji_emotions, // Replace with your reaction icon
                text: 'Reaction',
              ),
              // Participants
              buildOption(
                context,
                icon: Icons.people, // Replace with your participants icon
                text: 'Participants',
                onTap: (){
                  showParticipantBottomSheet();
                },
              ),
              // Live Stream
              buildOption(
                context,
                icon: Icons.live_tv, // Replace with your live stream icon
                text: 'Live Stream',
              ),
            ],
          ),
        ),
      ),
    );
  }

  void showParticipantBottomSheet() {
    Navigator.pop(context);
    Navigator.of(context).push(MaterialPageRoute<Null>(
        builder: (BuildContext context) {
          return const AllParticipantBottomsheet();
        },
        fullscreenDialog: true
    ));
  }
}

Widget buildOption(BuildContext context,
    {required IconData icon, required String text, bool isVisible = true, Function? onTap}) {
  return Visibility(
    visible: isVisible,
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      child: GestureDetector(
        onTap: () {
          // Null-safe invocation of the callback
          onTap?.call(); // callback will only be called if it's not null
        },
        child: Row(
          children: [
            Icon(icon, color: Colors.white, size: 24), // Icon size 24
            const SizedBox(width: 10), // Space between icon and text
            Text(
              text,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
