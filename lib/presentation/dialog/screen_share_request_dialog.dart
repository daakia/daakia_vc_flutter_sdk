import 'package:daakia_vc_flutter_sdk/model/remote_activity_data.dart';
import 'package:daakia_vc_flutter_sdk/viewmodel/rtc_viewmodel.dart';
import 'package:flutter/material.dart';
import '../widgets/screen_share_request_tile.dart';

class ScreenShareRequestDialog extends StatelessWidget {
  final RtcViewmodel viewModel; // list of participant names
  final void Function(RemoteActivityData request, bool allow) onAction;
  final VoidCallback onClose;

  const ScreenShareRequestDialog({
    super.key,
    required this.viewModel,
    required this.onAction,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.grey[900],
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          maxHeight: 260, // roughly fits 2 tiles, rest scrollable
          minWidth: 280,
          maxWidth: 400,
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Title Row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Screen Share Request",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.white70),
                    onPressed: onClose,
                  ),
                ],
              ),
              const SizedBox(height: 8),
              const Divider(color: Colors.white24),
              const SizedBox(height: 8),

              // Request List
              Expanded(
                child: ListView.builder(
                  itemCount: viewModel.screenShareRequestList.length,
                  itemBuilder: (context, index) {
                    final request = viewModel.screenShareRequestList[index];
                    final name = request.identity?.name ?? "Unknown";
                    return ScreenShareRequestTile(
                      name: name,
                      onAction: (allow) => onAction(request, allow),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
