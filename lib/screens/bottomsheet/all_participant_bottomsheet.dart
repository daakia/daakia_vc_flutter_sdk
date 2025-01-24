  import 'package:daakia_vc_flutter_sdk/screens/bottomsheet/pariticipant_dialog_controls.dart';
  import 'package:daakia_vc_flutter_sdk/screens/customWidget/participant_tile.dart';
  import 'package:daakia_vc_flutter_sdk/utils/utils.dart';
  import 'package:flutter/material.dart';
  import 'package:provider/provider.dart';

  import '../../resources/colors/color.dart';
  import '../../viewmodel/rtc_viewmodel.dart';

  class AllParticipantBottomsheet extends StatelessWidget {
    const AllParticipantBottomsheet({super.key});

    @override
    Widget build(BuildContext context) {
      final viewModel = Provider.of<RtcViewmodel>(context);
      return Scaffold(
        backgroundColor: emptyVideoColor,
        body: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20.0),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 10.0, bottom: 20.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back),
                      color: Colors.white,
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                    const SizedBox(width: 20.0),
                    const Expanded(
                      child: Text(
                        'Participant',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Visibility(
                          visible: viewModel.getLobbyRequestList().isNotEmpty,
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
                                shrinkWrap: true, // Let the list take only the space it needs
                                physics: const NeverScrollableScrollPhysics(), // Disable inner scrolling
                                itemCount: viewModel.getLobbyRequestList().length,
                                itemBuilder: (context, index) {
                                  var lobbyRequest = viewModel.getLobbyRequestList()[index];
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
                                    viewModel.acceptParticipant(
                                      request: viewModel.getLobbyRequestList()[0],
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
                        ),
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
                            if (Utils.isHost(viewModel.room.localParticipant?.metadata) ||
                                Utils.isCoHost(viewModel.room.localParticipant?.metadata))
                              IconButton(
                                onPressed: () {
                                  showParticipantDialog(context, viewModel);
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
                          itemCount: viewModel.getParticipantList().length,
                          itemBuilder: (context, index) {
                            var participant = viewModel.getParticipantList()[index];
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
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
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
