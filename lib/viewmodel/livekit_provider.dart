import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../model/meeting_details.dart';
import 'livekit_viewmodel.dart'; // Import your LivekitViewmodel
import 'package:livekit_client/livekit_client.dart';

class LivekitProvider extends StatefulWidget {
  final Room room;
  final MeetingDetails meetingDetails;
  final Widget child;

  const LivekitProvider({required this.room, required this.meetingDetails, required this.child, super.key});

  @override
  LivekitProviderState createState() => LivekitProviderState();
}

class LivekitProviderState extends State<LivekitProvider> {
  late LivekitViewmodel viewModel;

  @override
  void initState() {
    super.initState();
    viewModel = LivekitViewmodel(widget.room, widget.meetingDetails); // Initialize the view model
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<LivekitViewmodel>.value(
      value: viewModel,
      child: widget.child,
    );
  }
}

