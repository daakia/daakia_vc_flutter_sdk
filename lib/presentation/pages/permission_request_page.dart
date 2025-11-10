import 'package:daakia_vc_flutter_sdk/presentation/widgets/screen_share_request_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../viewmodel/rtc_viewmodel.dart';

class PermissionRequestPage extends StatelessWidget {
  const PermissionRequestPage({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<RtcViewmodel>(context);
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text("Permissions", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20.0),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (viewModel.screenShareRequestList.isNotEmpty &&
                    (viewModel.isHost() || viewModel.isCoHost()))
                  ScreenShareRequestWidget(viewModel: viewModel)
              ],
            ),
          ),
        ),
      ),
    );
  }
}
