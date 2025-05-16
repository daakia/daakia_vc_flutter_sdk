import 'package:daakia_vc_flutter_sdk/presentation/widgets/joined_participant_widget.dart';
import 'package:daakia_vc_flutter_sdk/presentation/widgets/lobby_request_widget.dart';
import 'package:daakia_vc_flutter_sdk/presentation/widgets/pending_attendance_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../resources/colors/color.dart';
import '../../viewmodel/rtc_viewmodel.dart';

class AllParticipantPage extends StatelessWidget {
  const AllParticipantPage({super.key});

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
                      LobbyRequestWidget(viewModel: viewModel),
                      JoinedParticipantWidget(viewModel: viewModel),
                      if (viewModel.pendingParticipantList.isNotEmpty && (viewModel.isHost() || viewModel.isCoHost()))
                        PendingAttendanceWidget(viewModel: viewModel)
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
}
