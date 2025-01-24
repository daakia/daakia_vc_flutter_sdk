import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MeetingManager {
  final String? endDate;
  Timer? popupTimer;
  Timer? endMeetingTimer;
  VoidCallback endMeetingCallBack;

  MeetingManager({required this.endDate, required this.endMeetingCallBack});

  void startMeetingEndScheduler(BuildContext context) {
    if (endDate == null || endDate!.isEmpty) {
      // If endDate is null or empty, skip scheduling
      return;
    }

    // Parse endDate
    final DateTime? endDateTime = _parseEndDate(endDate!);
    if (endDateTime == null) {
      // If parsing fails, log or handle the error
      debugPrint("Invalid endDate format");
      return;
    }

    final DateTime currentTime = DateTime.now();
    final Duration timeDifference = endDateTime.difference(currentTime);

    if (timeDifference.isNegative) {
      // If endDate is in the past, end the meeting immediately
      _endMeeting(context);
      return;
    }

    // Schedule popup 5 minutes before the end
    final Duration popupDuration = timeDifference - const Duration(minutes: 5);
    if (popupDuration > Duration.zero) {
      popupTimer = Timer(popupDuration, () {
        _showEndingSoonPopup(context);
      });
    }

    // Schedule meeting end
    endMeetingTimer = Timer(timeDifference, () {
      _endMeeting(context);
    });
  }

  void _showEndingSoonPopup(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Meeting Ending Soon"),
        content: const Text("The meeting will end in 5 minutes."),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }

  void _endMeeting(BuildContext context) {
    endMeetingCallBack.call();
  }

  void cancelMeetingEndScheduler() {
    // Cancel all timers
    popupTimer?.cancel();
    endMeetingTimer?.cancel();
  }

  DateTime? _parseEndDate(String endDate) {
    try {
      return DateFormat("yyyy-MM-ddTHH:mm:ss.SSSZ").parse(endDate, true).toLocal();
    } catch (e) {
      debugPrint("Error parsing endDate: $e");
      return null;
    }
  }

  /// Function to check if the meeting has ended
  bool isMeetingEnded() {
    if (endDate == null || endDate!.isEmpty) {
      return false; // No end date, so the meeting is ongoing
    }

    final DateTime? endDateTime = _parseEndDate(endDate!);
    if (endDateTime == null) {
      return false; // Unable to parse the end date, assume ongoing
    }

    final DateTime currentTime = DateTime.now();
    return currentTime.isAfter(endDateTime); // Check if the current time is past the end time
  }
}
