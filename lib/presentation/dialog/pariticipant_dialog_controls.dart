import 'package:flutter/material.dart';
import 'package:livekit_client/livekit_client.dart';

import '../../model/action_model.dart';
import '../../utils/meeting_actions.dart';
import '../../utils/utils.dart';
import '../../viewmodel/rtc_viewmodel.dart';
import '../pages/chat_controller.dart';

class ParticipantDialogControls extends StatefulWidget {
  const ParticipantDialogControls(
      {required this.participant,
      required this.viewModel,
      this.isForIndividual = true,
      this.onDismissBottomSheet,
      super.key});

  final Participant participant;
  final bool isForIndividual;
  final RtcViewmodel viewModel;
  final VoidCallback? onDismissBottomSheet;

  @override
  State<StatefulWidget> createState() {
    return ParticipantDialogState();
  }
}

class ParticipantDialogState extends State<ParticipantDialogControls> {
  @override
  Widget build(BuildContext context) {
    String? myRoleMataData = widget.viewModel.room.localParticipant?.metadata;
    String? targetRoleMataData = widget.participant.metadata;
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      backgroundColor: Colors.transparent,
      child: Card(
        color: Colors.grey[900], // Replace with your color
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomTextItem(
                text: widget.participant.isMicrophoneEnabled()
                    ? "Mute Mic"
                    : "Ask To Unmute Mic",
                onTap: () {
                  Navigator.pop(context);
                  widget.viewModel.sendPrivateAction(
                      ActionModel(
                          action: widget.participant.isMicrophoneEnabled()
                              ? MeetingActions.muteMic
                              : MeetingActions.askToUnmuteMic),
                      widget.participant.identity);
                },
                isVisible: (widget.isForIndividual &&
                    (Utils.isHost(myRoleMataData) ||
                        Utils.isCoHost(myRoleMataData))),
              ),
              CustomTextItem(
                text: widget.participant.isCameraEnabled()
                    ? "Turn Off Camera"
                    : "Ask To Turn ON Camera",
                onTap: () {
                  Navigator.pop(context);
                  widget.viewModel.sendPrivateAction(
                      ActionModel(
                          action: widget.participant.isCameraEnabled()
                              ? MeetingActions.muteCamera
                              : MeetingActions.askToUnmuteCamera),
                      widget.participant.identity);
                },
                isVisible: (widget.isForIndividual &&
                    (Utils.isHost(myRoleMataData) ||
                        Utils.isCoHost(myRoleMataData))),
              ),
              CustomTextItem(
                  text: Utils.isCoHost(widget.participant.metadata)
                      ? "Remove Co-Host"
                      : "Make Co-Host",
                  onTap: () {
                    Navigator.pop(context);
                    widget.viewModel.makeCoHost(widget.participant.identity,
                        !Utils.isCoHost(widget.participant.metadata));
                  },
                  isVisible: (widget.isForIndividual && isCoHostButtonEnable())),
              CustomTextItem(
                text: "Remove From Call",
                onTap: () {
                  Navigator.pop(context);
                  widget.viewModel.removeFromCall(widget.participant.identity);
                },
                isVisible: (widget.isForIndividual &&
                    (Utils.isHost(myRoleMataData) ||
                        (Utils.isCoHost(myRoleMataData) &&
                            !Utils.isHost(targetRoleMataData)))),
              ),
              CustomTextItem(
                text: "Send private message",
                onTap: () {
                  // Dismiss the ParticipantDialogControls
                  Navigator.of(context, rootNavigator: false).pop();
                  if (widget.onDismissBottomSheet != null) {
                    widget.onDismissBottomSheet!();
                  }
                  widget.viewModel.checkAndCreatePrivateChat(
                      widget.participant.identity, widget.participant.name);
                  showChatBottomSheet(widget.viewModel,
                      widget.participant.identity, widget.participant.name);
                },
                isVisible: widget.isForIndividual,
              ),
              CustomTextItem(
                text: "Mute All",
                onTap: () {
                  Navigator.pop(context);
                  widget.viewModel.sendAction(ActionModel(action: MeetingActions.muteMic));
                },
                isVisible: !widget.isForIndividual,
              ),
              CustomTextItem(
                text: "Video Off All",
                onTap: () {
                  Navigator.pop(context);
                  widget.viewModel
                      .sendAction(ActionModel(action: MeetingActions.muteCamera));
                },
                isVisible: !widget.isForIndividual,
              ),
              CustomTextItem(
                text: "Lower Hands All",
                onTap: () {
                  Navigator.pop(context);
                  widget.viewModel
                      .sendAction(ActionModel(action: MeetingActions.stopRaiseHandAll));
                  widget.viewModel.stopHandRaisedForAll();
                },
                isVisible: !widget.isForIndividual &&
                    widget.viewModel.meetingDetails.features!
                        .isRaiseHandAllowed(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  bool isCoHostButtonEnable() {
    String? myRoleMataData = widget.viewModel.room.localParticipant?.metadata;
    String? targetRoleMataData = widget.participant.metadata;

    bool isHostUser = Utils.isHost(myRoleMataData);
    bool isTargetNotHost = !Utils.isHost(targetRoleMataData);
    bool isTargetCoHost = Utils.isCoHost(targetRoleMataData);

    // Host can always remove Co-Host
    if (isHostUser && isTargetCoHost) {
      return true;
    }

    // Host can make someone co-host
    if (isHostUser && isTargetNotHost) {
      if (widget.viewModel.meetingDetails.features?.isAllowMultipleCoHost() == true) {
        return true;
      } else {
        return widget.viewModel.coHostCount < 1;
      }
    }

    return false;
  }

  void showChatBottomSheet(
      RtcViewmodel viewmodel, String identity, String name) {
    Navigator.of(context).push(MaterialPageRoute<Null>(
        builder: (BuildContext context) {
          return ChatController(
            identity: identity,
            name: name,
            viewModel: viewmodel,
          );
        },
        fullscreenDialog: true));
  }
}

class CustomTextItem extends StatelessWidget {
  final String text;
  final bool isVisible;
  final VoidCallback onTap;

  const CustomTextItem({
    super.key,
    required this.text,
    required this.onTap,
    this.isVisible = true,
  });

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: isVisible,
      child: TextButton(
        onPressed: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Text(
            text,
            style: const TextStyle(fontSize: 18, color: Colors.white),
          ),
        ),
      ),
    );
  }
}
