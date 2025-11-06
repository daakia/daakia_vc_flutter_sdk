import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../viewmodel/rtc_viewmodel.dart';
import '../widgets/host_control_switch.dart';

class WebinarControls extends StatelessWidget {
  const WebinarControls({super.key});

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
              padding: const EdgeInsets.only(top: 20, bottom: 10),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  const Text(
                    'Host Control',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            // Divider
            const Divider(color: Colors.white, thickness: 0.8),
            // Message
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 20),
              child: Text(
                'Stay in control of your meetings with advanced host options.',
                style: TextStyle(color: Colors.white, fontSize: 15),
                textAlign: TextAlign.center,
              ),
            ),
            // Webinar Mode Switch
            HostControlSwitch(
              title: 'Webinar mode',
              subtitle:
                  'If turned ON, all participants except Hosts / CoHosts stay muted with their camera off.',
              value: viewModel.isWebinarModeEnable,
              onChanged: (value) => viewModel.isWebinarModeEnable = value,
              isDividerRequired: false,
            ),
            // Participants Audio Switch
            HostControlSwitch(
              title: 'Participants Audio',
              subtitle: 'If turned off, participants can unmute themselves.',
              value: viewModel.isAudioModeEnable,
              onChanged: (value) => viewModel.isAudioModeEnable = value,
              isChild: true,
              // 👈 smaller + indented
              isDividerRequired: false,
            ),
            // Participants Video Switch
            HostControlSwitch(
              title: 'Participants Video',
              subtitle: 'If turned off, participants can turn their camera on.',
              value: viewModel.isVideoModeEnable,
              onChanged: (value) => viewModel.isVideoModeEnable = value,
              isChild: true,
              // 👈 smaller + indented
              isDividerRequired: false,
            ),
            // Divider
            const Divider(color: Colors.white),
            HostControlSwitch(
              title: 'Allow Screen Share',
              subtitle: 'If turned ON, all participants will be able to share their screen without the permission of Host / Co-Host.',
              value: viewModel.isScreenShareEnable,
              isEnable: viewModel.meetingDetails.features?.isScreenShareRequestAllowed() == true,
              onChanged: (value) => viewModel.isScreenShareEnable = value,
            ),
          ],
        ),
      ),
    );
  }
}
