import 'package:daakia_vc_flutter_sdk/screens/bottomsheet/pariticipant_dialog_controls.dart';
import 'package:daakia_vc_flutter_sdk/screens/customWidget/participant_tile.dart';
import 'package:daakia_vc_flutter_sdk/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../resources/colors/color.dart';
import '../../viewmodel/livekit_viewmodel.dart';

class AllParticipantBottomsheet extends StatelessWidget {
  const AllParticipantBottomsheet({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<LivekitViewmodel>(context);
    return Scaffold(
      backgroundColor:  emptyVideoColor, // Replace with your color
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
                    icon: const Icon(Icons.arrow_back), // Replace with your custom icon if needed
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
                        fontSize: 20.0, // Replace with your `dimen_20_sp`
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
                            SizedBox(
                              height: 200.0, // Adjust height as needed
                              child: ListView.builder(
                                itemCount: viewModel.getLobbyRequestList().length, // Replace with dynamic count
                                itemBuilder: (context, index) {
                                  var lobbyRequest = viewModel.getLobbyRequestList()[index];
                                  return ListTile(
                                    title: ParticipantTile(participant: lobbyRequest.identity, isForLobby: false,),
                                  );
                                },
                              ),
                            ),
                            const SizedBox(height: 10.0),
                            Center(
                              child: TextButton(
                                onPressed: () {
                                  // Handle 'Accept All' button action
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
                        mainAxisAlignment: MainAxisAlignment.spaceBetween, // Places text on left and icon on right
                        children: [
                          const Text(
                            'Participants',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          if(Utils.isHost(viewModel.room.localParticipant?.metadata) || Utils.isCoHost(viewModel.room.localParticipant?.metadata))
                          IconButton(onPressed: (){
                            showParticipantDialog(context, viewModel);
                          }, icon: const Icon(
                            Icons.more_vert, // Replace with your desired icon
                            color: Colors.white,
                          ),)
                        ],
                      ),
                      const SizedBox(height: 10.0),
                      SizedBox(
                        height: 300.0, // Adjust height as needed
                        child: ListView.builder(
                          itemCount: viewModel.getParticipantList().length, // Replace with dynamic count
                          itemBuilder: (context, index) {
                            var participant = viewModel.getParticipantList()[index];
                            return ListTile(
                              title: ParticipantTile(participant: participant.participant, isForLobby: false,),
                            );
                          },
                        ),
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

  void showParticipantDialog(BuildContext context, LivekitViewmodel viewModel) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return ParticipantDialogControls(participant: viewModel.participant, viewModel: viewModel, isForIndividual: false,);
        });
  }
}
