import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../viewmodel/rtc_viewmodel.dart';

class WebinarControls extends StatelessWidget {
  const WebinarControls({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<RtcViewmodel>(context);
    return Scaffold(
      backgroundColor: const Color(0xFF000000), // Replace with your desired background color
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
            SwitchListTile(
              value: viewModel.isWebinarModeEnable,
              onChanged: (value) {
                viewModel.isWebinarModeEnable = value;
              },
              title: const Text(
                'Webinar mode',
                style: TextStyle(color: Colors.white, fontSize: 25, fontWeight: FontWeight.w600),
              ),
              subtitle: const Text(
                'If turned ON, all participants except Hosts / CoHosts stay muted with their camera off.',
                style: TextStyle(color: Colors.white, fontSize: 15),
              ),
              activeColor: Colors.greenAccent, // Customize based on your design
            ),
            // Divider
            const Divider(color: Colors.white),
            // Participants Audio Switch
            SwitchListTile(
              value: viewModel.isAudioModeEnable,
              onChanged: (value) {
                viewModel.isAudioModeEnable = value;
              },
              title: const Text(
                'Participants Audio',
                style: TextStyle(color: Colors.white, fontSize: 25, fontWeight: FontWeight.w600),
              ),
              subtitle: const Text(
                'If turned off, participants can unmute themselves.',
                style: TextStyle(color: Colors.white, fontSize: 15),
              ),
              activeColor: Colors.greenAccent, // Customize based on your design
            ),
            // Divider
            const Divider(color: Colors.white),
            // Participants Video Switch
            SwitchListTile(
              value: viewModel.isVideoModeEnable,
              onChanged: (value) {
                viewModel.isVideoModeEnable = value;
              },
              title: const Text(
                'Participants Video',
                style: TextStyle(color: Colors.white, fontSize: 25, fontWeight: FontWeight.w600),
              ),
              subtitle: const Text(
                'If turned off, participants can turn their camera on.',
                style: TextStyle(color: Colors.white, fontSize: 15),
              ),
              activeColor: Colors.greenAccent, // Customize based on your design
            ),
            // Divider
            const Divider(color: Colors.white),
          ],
        ),
      ),
    );
  }
}
