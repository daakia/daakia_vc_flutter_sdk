import 'package:daakia_vc_flutter_sdk/model/remote_activity_data.dart';
import 'package:daakia_vc_flutter_sdk/resources/colors/color.dart';
import 'package:daakia_vc_flutter_sdk/presentation/dialog/pariticipant_dialog_controls.dart';
import 'package:daakia_vc_flutter_sdk/presentation/widgets/initials_circle.dart';
import 'package:daakia_vc_flutter_sdk/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:livekit_client/livekit_client.dart';
import 'package:provider/provider.dart';

import '../../viewmodel/rtc_viewmodel.dart';

class ParticipantTile extends StatelessWidget {
  const ParticipantTile(
      {required this.participant,
      this.isForLobby = false,
      super.key,
      this.lobbyRequest,
      this.onDismissBottomSheet});

  final Participant? participant;
  final bool isForLobby;
  final RemoteActivityData? lobbyRequest;
  final VoidCallback? onDismissBottomSheet;

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<RtcViewmodel>(context);
    return Container(
      color: emptyVideoColor,
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Initials Circle
          InitialsCircle(
              initials: Utils.getInitials(
                  isForLobby ? lobbyRequest?.displayName : participant?.name),
              onEdit: (!isForLobby &&
                      ((participant?.identity ==
                              viewModel.room.localParticipant?.identity) ||
                          (viewModel.isHost() || viewModel.isCoHost())))
                  ? () {
                      _showEditNameDialog(context, viewModel);
                    }
                  : null),
          const SizedBox(width: 10),
          // Name and Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  (isForLobby
                          ? lobbyRequest?.displayName
                          : participant?.name) ??
                      "Unknown",
                  // Replace with the participant's name
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                if (!isForLobby)
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
                    viewModel.acceptParticipant(
                        request: lobbyRequest, accept: false);
                  },
                ),
              ),
              Visibility(
                visible: isForLobby,
                child: IconButton(
                  icon: const Icon(Icons.check, color: Colors.white),
                  iconSize: 25,
                  onPressed: () {
                    viewModel.acceptParticipant(
                        request: lobbyRequest, accept: true);
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
                  icon: const Icon(Icons.more_vert, color: Colors.white),
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
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return ParticipantDialogControls(
            participant: participant as Participant,
            viewModel: viewModel,
            onDismissBottomSheet: () {
              if (onDismissBottomSheet != null) {
                onDismissBottomSheet!();
              }
            },
          );
        });
  }

  void _showEditNameDialog(BuildContext context, RtcViewmodel viewModel) {
    final TextEditingController nameController =
        TextEditingController(text: participant?.name ?? "");

    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Edit Name"),
            content: TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: "Enter new name",
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Close dialog
                },
                child: const Text("Cancel"),
              ),
              TextButton(
                onPressed: () {
                  final newName = nameController.text.trim();
                  if (newName.isNotEmpty) {
                    viewModel.updateParticipantName(
                        participant: participant?.identity, newName: newName);
                  }
                  Navigator.of(context).pop(); // Close dialog
                },
                child: const Text("Save"),
              ),
            ],
          );
        });
  }
}
