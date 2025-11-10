import 'package:daakia_vc_flutter_sdk/presentation/widgets/screen_share_request_tile.dart';
import 'package:flutter/material.dart';

import '../../viewmodel/rtc_viewmodel.dart';

class ScreenShareRequestWidget extends StatefulWidget {
  const ScreenShareRequestWidget({required this.viewModel, super.key});

  final RtcViewmodel viewModel;

  @override
  State<ScreenShareRequestWidget> createState() =>
      _ScreenShareRequestWidgetState();
}

class _ScreenShareRequestWidgetState extends State<ScreenShareRequestWidget> {
  bool isExpanded = true; // Track if the list is expanded

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Screen Share Requests',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            IconButton(
              onPressed: () {
                setState(() {
                  isExpanded = !isExpanded; // Toggle list visibility
                });
              },
              icon: Icon(
                isExpanded
                    ? Icons.arrow_drop_down_sharp
                    : Icons.arrow_right_sharp,
                color: Colors.white,
              ),
            ),
          ],
        ),
        if (isExpanded)
          ConstrainedBox(
            constraints: const BoxConstraints(),
            child: ListView.builder(
              shrinkWrap: true,
              padding: EdgeInsets.zero,
              // important!
              physics: const NeverScrollableScrollPhysics(),
              itemCount: widget.viewModel.screenShareRequestList.length,
              itemBuilder: (context, index) {
                final request = widget.viewModel.screenShareRequestList[index];
                final name = request.identity?.name ?? "Unknown";
                return ScreenShareRequestTile(
                  name: name,
                  onAction: (allow) {
                    widget.viewModel.handleScreenShareRequest(allow, request);
                    widget.viewModel.removeScreenShareRequest(request);
                  },
                );
              },
            ),
          ),
      ],
    );
  }
}
