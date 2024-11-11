import 'package:daakia_vc_flutter_sdk/resources/colors/color.dart';
import 'package:daakia_vc_flutter_sdk/screens/bottomsheet/pariticipant_dialog_controls.dart';
import 'package:daakia_vc_flutter_sdk/screens/customWidget/initials_circle.dart';
import 'package:daakia_vc_flutter_sdk/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:livekit_client/livekit_client.dart';
import 'package:provider/provider.dart';

import '../../viewmodel/rtc_viewmodel.dart';

class ParticipantTile extends StatelessWidget {
  const ParticipantTile(
      {@required this.participant, this.isForLobby = false, super.key});

  final Participant? participant;
  final bool isForLobby;

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<RtcViewmodel>(context);
    return Container(
      color: emptyVideoColor,
      padding: const EdgeInsets.all(10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Initials Circle
          InitialsCircle(initials: Utils.getInitials(participant?.name)),
          const SizedBox(width: 10),
          // Name and Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  participant?.name ?? "Unknown",
                  // Replace with the participant's name
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  "${Utils.calculateMinutesSince(participant?.joinedAt)} mins ${Utils.getParticipantType(participant?.metadata)}", // Replace with details text
                  style: const TextStyle(
                    color: Color(0xFFC4C1B8),
                    // Equivalent to the text color used
                    fontSize: 12,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          // Options Icons
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Visibility(
                visible: isForLobby,
                child: IconButton(
                  icon: const Icon(Icons.close, color: Colors.white),
                  iconSize: 25,
                  onPressed: () {
                    // Handle reject action
                  },
                ),
              ),
              Visibility(
                visible: isForLobby,
                child: IconButton(
                  icon: const Icon(Icons.check, color: Colors.white),
                  iconSize: 25,
                  onPressed: () {
                    // Handle accept action
                  },
                ),
              ),
              Visibility(
                visible: !isForLobby,
                child: IconButton(
                  icon: Icon(
                      participant?.isCameraEnabled() == true
                          ? Icons.videocam
                          : Icons.videocam_off,
                      color: Colors.white),
                  iconSize: 25,
                  onPressed: () {
                    // Handle video action
                  },
                ),
              ),
              Visibility(
                visible: !isForLobby,
                child: IconButton(
                  icon: Icon(
                      participant?.isMicrophoneEnabled() == true
                          ? Icons.mic
                          : Icons.mic_off,
                      color: Colors.white),
                  iconSize: 25,
                  onPressed: () {
                    // Handle mic action
                  },
                ),
              ),
              Visibility(
                visible: (!isForLobby &&
                    participant?.identity !=
                        viewModel.room.localParticipant?.identity),
                child: IconButton(
                  icon: Icon(Icons.more_vert,
                      color: Colors.white.withOpacity(
                          (viewModel.isHost() || viewModel.isCoHost())
                              ? 1
                              : 0.5)),
                  iconSize: 25,
                  onPressed: () {
                    showParticipantDialog(context, viewModel);
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void showParticipantDialog(BuildContext context, RtcViewmodel viewModel) {
    if (viewModel.isHost() || viewModel.isCoHost()) {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return ParticipantDialogControls(
              participant: participant as Participant,
              viewModel: viewModel,
            );
          });
    }
  }
}
