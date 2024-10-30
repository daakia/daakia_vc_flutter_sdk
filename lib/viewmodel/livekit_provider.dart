import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'livekit_viewmodel.dart'; // Import your LivekitViewmodel
import 'package:livekit_client/livekit_client.dart';

class LivekitProvider extends StatefulWidget {
  final Room room;
  final Widget child;

  const LivekitProvider({required this.room, required this.child, Key? key}) : super(key: key);

  @override
  LivekitProviderState createState() => LivekitProviderState();
}

class LivekitProviderState extends State<LivekitProvider> {
  late LivekitViewmodel viewModel;

  @override
  void initState() {
    super.initState();
    viewModel = LivekitViewmodel(widget.room); // Initialize the view model
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<LivekitViewmodel>.value(
      value: viewModel,
      child: widget.child,
    );
  }
}

