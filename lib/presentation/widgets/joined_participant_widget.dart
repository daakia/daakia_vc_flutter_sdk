import 'package:daakia_vc_flutter_sdk/presentation/widgets/participant_tile.dart';
import 'package:flutter/material.dart';

import '../../utils/utils.dart';
import '../../viewmodel/rtc_viewmodel.dart';
import '../dialog/pariticipant_dialog_controls.dart';

class JoinedParticipantWidget extends StatefulWidget {
  const JoinedParticipantWidget({required this.viewModel, super.key});

  final RtcViewmodel viewModel;

  @override
  State<JoinedParticipantWidget> createState() => _JoinedParticipantWidgetState();
}

class _JoinedParticipantWidgetState extends State<JoinedParticipantWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Participants',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            if (Utils.isHost(widget.viewModel.room.localParticipant?.metadata) ||
                Utils.isCoHost(widget.viewModel.room.localParticipant?.metadata))
              IconButton(
                onPressed: () {
                  showParticipantDialog(context, widget.viewModel);
                },
                icon: const Icon(
                  Icons.more_vert,
                  color: Colors.white,
                ),
              ),
          ],
        ),
        ListView.builder(
          shrinkWrap: true, // Let the list take only the space it needs
          physics: const NeverScrollableScrollPhysics(), // Disable inner scrolling
          itemCount: widget.viewModel.getParticipantList().length,
          itemBuilder: (context, index) {
            var participant = widget.viewModel.getParticipantList()[index];
            return ListTile(
              title: ParticipantTile(
                participant: participant.participant,
                isForLobby: false,
                onDismissBottomSheet: (){
                  if (Navigator.of(context).canPop()) {
                    Navigator.of(context).pop(); // This will dismiss the BottomSheet
                  }
                },
              ),
            );
          },
        ),
      ],
    );
  }

  void showParticipantDialog(BuildContext context, RtcViewmodel viewModel) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return ParticipantDialogControls(participant: viewModel.participant, viewModel: viewModel, isForIndividual: false,);
        });
  }

}
