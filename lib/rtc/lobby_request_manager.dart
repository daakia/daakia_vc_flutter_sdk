import 'dart:async';
import 'dart:collection';

import 'package:daakia_vc_flutter_sdk/presentation/widgets/initials_circle.dart';
import 'package:daakia_vc_flutter_sdk/viewmodel/rtc_viewmodel.dart';
import 'package:flutter/material.dart';

import '../model/remote_activity_data.dart';
import '../utils/utils.dart';

class LobbyRequestManager {
  // Queue to hold requests
  final Queue<RemoteActivityData> _lobbyRequestQueue = Queue<RemoteActivityData>();
  bool _isShowingDialog = false;
  final BuildContext? _context;
  final RtcViewmodel? viewModel;

  LobbyRequestManager(this._context, this.viewModel);

  void showLobbyRequestDialog(RemoteActivityData remoteData) {
    // Check if request_id already exists in the queue
    if (_lobbyRequestQueue.any((request) => request.requestId == remoteData.requestId)) {
      return; // Skip duplicate request
    }

    // Add new request to queue
    _lobbyRequestQueue.add(remoteData);

    // If no dialog is currently showing, process the queue
    if (!_isShowingDialog) {
      _processNextLobbyRequest();
    }
  }

  void _processNextLobbyRequest() {
    // Get next request from queue
    final nextRequest = _lobbyRequestQueue.isNotEmpty ? _lobbyRequestQueue.removeFirst() : null;

    if (nextRequest == null) {
      _isShowingDialog = false;
      return; // Exit if no more requests
    }

    _isShowingDialog = true;

    // Show the dialog
    _showDialogForRequest(nextRequest);
  }

  void _showDialogForRequest(RemoteActivityData request) {
    final timer = Timer(const Duration(seconds: 3), () {
      _dismissDialog(); // Automatically dismiss after 3 seconds
    });

    showDialog(
      context: _context!,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: LobbyRequestDialog(
            remoteData: request,
            onAccept: (accepted) {
              viewModel?.acceptParticipant(request: request, accept: accepted);
              timer.cancel(); // Cancel timer when button is clicked
              _dismissDialog();
            },
          ),
        );
      },
    ).then((_) => _processNextLobbyRequest());
  }

  void _dismissDialog() {
    _isShowingDialog = false;
    if (_context != null) {
      Navigator.of(_context).pop();
    }
  }

  void dispose() {
    _dismissDialog();
    _lobbyRequestQueue.clear();
    _isShowingDialog = false;
  }
}

class LobbyRequestDialog extends StatelessWidget {
  final RemoteActivityData remoteData;
  final Function(bool accepted) onAccept;

  const LobbyRequestDialog({super.key, required this.remoteData, required this.onAccept});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.grey[900],
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "New participant wants to join",
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                InitialsCircle(initials: Utils.getInitials(remoteData.displayName)),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    remoteData.displayName ?? "",
                    style: const TextStyle(color: Colors.white, fontSize: 16),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Colors.redAccent),
                    foregroundColor: Colors.redAccent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  ),
                  onPressed: () => onAccept(false),
                  child: const Text("Reject"),
                ),
                const SizedBox(width: 12),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.greenAccent[700],
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  ),
                  onPressed: () => onAccept(true),
                  child: const Text("Accept"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
