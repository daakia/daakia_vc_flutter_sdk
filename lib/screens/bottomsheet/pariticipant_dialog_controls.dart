import 'package:flutter/material.dart';
import 'package:livekit_client/livekit_client.dart';

import '../../model/action_model.dart';
import '../../utils/utils.dart';
import '../../viewmodel/livekit_viewmodel.dart';

class ParticipantDialogControls extends StatelessWidget{
  const ParticipantDialogControls({required this.participant, required this.viewModel, this.isForIndividual = true, super.key});
  final Participant participant;
  final bool isForIndividual;
  final LivekitViewmodel viewModel;

  @override
  Widget build(BuildContext context) {
    String? myRoleMataData = viewModel.room.localParticipant?.metadata;
    String? targetRoleMataData = participant.metadata;
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
                text: participant.isMicrophoneEnabled() ? "Mute Mic" : "Ask To Unmute Mic",
                onTap: () {
                  Navigator.pop(context);
                  viewModel.sendPrivateAction(ActionModel(action: participant.isMicrophoneEnabled() ? "mute_mic" : "ask_to_unmute_mic"), participant.identity);
                },
                isVisible: (isForIndividual && (Utils.isHost(myRoleMataData) || Utils.isCoHost(myRoleMataData) )),
              ),
              CustomTextItem(
                text: participant.isCameraEnabled() ? "Turn Off Camera" : "Ask To Turn ON Camera",
                onTap: () {
                  Navigator.pop(context);
                  viewModel.sendPrivateAction(ActionModel(action: participant.isCameraEnabled() ? "mute_camera" : "ask_to_unmute_camera"), participant.identity);
                },
                isVisible: (isForIndividual && (Utils.isHost(myRoleMataData) || Utils.isCoHost(myRoleMataData) )),
              ),
              CustomTextItem(
                text: Utils.isCoHost(participant.metadata) ? "Remove Co-Host" : "Make Co-Host",
                onTap: () {
                  Navigator.pop(context);
                  viewModel.makeCoHost(participant.identity, !Utils.isCoHost(participant.metadata));
                },
                isVisible:  (isForIndividual && Utils.isHost(myRoleMataData) && !Utils.isHost(targetRoleMataData))
              ),
              CustomTextItem(
                text: "Remove From Call",
                onTap: () {
                  Navigator.pop(context);
                  viewModel.removeFromCall(participant.identity);
                },
                isVisible: (isForIndividual && (Utils.isHost(myRoleMataData) || (Utils.isCoHost(myRoleMataData) && !Utils.isHost(targetRoleMataData)))),
              ),
              CustomTextItem(
                text: "Mute All",
                onTap: () {
                  Navigator.pop(context);
                  viewModel.sendAction(ActionModel(action: "mute_mic"));
                },
                isVisible: !isForIndividual,
              ),
              CustomTextItem(
                text: "Video Off All",
                onTap: () {
                  Navigator.pop(context);
                  viewModel.sendAction(ActionModel(action: "mute_camera"));
                },
                isVisible: !isForIndividual,
              ),
              CustomTextItem(
                text: "Lower Hands All",
                onTap: () {
                  Navigator.pop(context);
                  viewModel.sendAction(ActionModel(action: "stop_raise_hand_all"));
                },
                isVisible: !isForIndividual,
              ),
            ],
          ),
        ),
      ),
    );
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
