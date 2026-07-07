import 'package:flutter/material.dart';

import '../../viewmodel/rtc_viewmodel.dart';

class InvitedParticipantWidget extends StatefulWidget {
  const InvitedParticipantWidget({required this.viewModel, super.key});

  final RtcViewmodel viewModel;

  @override
  State<InvitedParticipantWidget> createState() =>
      _InvitedParticipantWidgetState();
}

class _InvitedParticipantWidgetState extends State<InvitedParticipantWidget> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final invitedList = widget.viewModel.invitedParticipantList;
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Participants Not Joined (${invitedList.length})',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            Row(
              children: [
                TextButton(
                  onPressed: widget.viewModel.remindAllParticipants,
                  child: const Text('Remind All'),
                ),
                IconButton(
                  onPressed: () {
                    setState(() {
                      isExpanded = !isExpanded;
                    });
                  },
                  icon: Icon(
                    isExpanded
                        ? Icons.arrow_drop_down_sharp
                        : Icons.arrow_right_sharp,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ],
        ),
        if (isExpanded)
          ListView.builder(
            shrinkWrap: true,
            padding: EdgeInsets.zero,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: invitedList.length,
            itemBuilder: (context, index) {
              final invitee = invitedList[index];
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 2.0),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        invitee.attendee ?? "Unknown",
                        style: const TextStyle(color: Colors.white),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    IconButton(
                      tooltip: 'Remind',
                      onPressed: invitee.attendee == null
                          ? null
                          : () => widget.viewModel
                              .remindParticipant(invitee.attendee!),
                      icon: const Icon(Icons.notifications_active_outlined,
                          color: Colors.white),
                    ),
                  ],
                ),
              );
            },
          ),
      ],
    );
  }
}
