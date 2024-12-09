import 'dart:async';
import 'dart:collection';

import 'package:daakia_vc_flutter_sdk/screens/customWidget/initials_circle.dart';
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
        padding: const EdgeInsets.all(5.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text("Someone wants to join!", style: TextStyle(color: Colors.white, fontSize: 20)),
            const SizedBox(height: 10,),
            Row(
              children: [
                const SizedBox(width: 5,),
                InitialsCircle(initials: Utils.getInitials(remoteData.displayName)),
                const SizedBox(width: 10,),
                Text(remoteData.displayName ?? "", style: const TextStyle(color: Colors.white, fontSize: 18)),
              ],
            ),
            const SizedBox(height: 10,),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => onAccept(false), // Reject action
                  child: const Text("Reject"),
                ),
                TextButton(
                  onPressed: () => onAccept(true), // Accept action
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
