import 'package:daakia_vc_flutter_sdk/presentation/widgets/participant_tile.dart';
import 'package:daakia_vc_flutter_sdk/viewmodel/rtc_viewmodel.dart';
import 'package:flutter/material.dart';

class LobbyRequestWidget extends StatefulWidget {
  const LobbyRequestWidget({required this.viewModel, super.key});

  final RtcViewmodel viewModel;

  @override
  State<LobbyRequestWidget> createState() => _LobbyRequestWidgetState();
}

class _LobbyRequestWidgetState extends State<LobbyRequestWidget> {
  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: widget.viewModel.getLobbyRequestList().isNotEmpty,
      child: Column(
        children: [
          const Text(
            'Waiting in Lobby',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10.0),
          ListView.builder(
            shrinkWrap: true,
            // Let the list take only the space it needs
            physics: const NeverScrollableScrollPhysics(),
            // Disable inner scrolling
            itemCount: widget.viewModel.getLobbyRequestList().length,
            itemBuilder: (context, index) {
              var lobbyRequest = widget.viewModel.getLobbyRequestList()[index];
              return ListTile(
                title: ParticipantTile(
                  participant: lobbyRequest.identity,
                  isForLobby: true,
                  lobbyRequest: lobbyRequest,
                ),
              );
            },
          ),
          const SizedBox(height: 10.0),
          Center(
            child: TextButton(
              onPressed: () {
                widget.viewModel.acceptParticipant(
                  request: widget.viewModel.getLobbyRequestList()[0],
                  accept: true,
                  acceptAll: true,
                );
              },
              child: const Text(
                'Accept All',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const Divider(
            color: Colors.white,
            thickness: 1.0,
          ),
          const SizedBox(height: 20.0),
        ],
      ),
    );
  }
}
