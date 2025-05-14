import 'package:daakia_vc_flutter_sdk/presentation/widgets/recording_consent_tile.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../viewmodel/rtc_viewmodel.dart';

class RecordingConsentPage extends StatefulWidget {
  const RecordingConsentPage({super.key});

  @override
  State<RecordingConsentPage> createState() => _RecordingConsentPageState();
}

class _RecordingConsentPageState extends State<RecordingConsentPage> {
  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<RtcViewmodel>(context);
    return Scaffold(
      backgroundColor: const Color(0xFF000000),
      // Replace with your desired background color
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Toolbar
            Padding(
              padding: const EdgeInsets.only(top: 20, bottom: 5),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  const Text(
                    'Recording Consent',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            const Divider(color: Colors.white, thickness: 0.8),

            /// ✅ Wrap ListView in Expanded
            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.zero,
                itemCount: viewModel.participantListForConsent.length,
                itemBuilder: (context, index) {
                  var participant = viewModel.participantListForConsent[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 2.0),
                    child: RecordingConsentTile(participant: participant),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
