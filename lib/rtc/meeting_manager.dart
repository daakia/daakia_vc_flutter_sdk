import 'dart:async';
import 'package:daakia_vc_flutter_sdk/events/meeting_end_events.dart';
import 'package:daakia_vc_flutter_sdk/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MeetingManager {
  DateTime? endDateTime;
  Timer? popupTimer;
  Timer? endMeetingTimer;
  Function(MeetingEndEvents event) endMeetingCallBack;
  bool? isAutoMeetingEnd = false;
  late BuildContext _globalContext; // Store a safe context

  MeetingManager({required String? endDate, required this.endMeetingCallBack, required BuildContext context, this.isAutoMeetingEnd}) {
    _globalContext = context; // Store a parent-level context
    endDateTime = _parseEndDate(endDate);
    if (endDateTime == null) {
      debugPrint("Error: Invalid endDate format. Meeting scheduling will not proceed.");
    }
  }

  bool _canExtendMeeting() => isAutoMeetingEnd == true;

  void startMeetingEndScheduler() {
    if (endDateTime == null) {
      debugPrint("Skipping scheduling due to invalid endDate.");
      return;
    }
    _scheduleTimers();
  }

  void _scheduleTimers() {
    if (endDateTime == null) return;

    final DateTime currentTime = DateTime.now();
    final Duration timeDifference = endDateTime!.difference(currentTime);

    if (timeDifference.isNegative) {
      _endMeeting();
      return;
    }

    // Schedule popup MEETING_ENDING_SOON_TIME minutes before the end time
    final Duration popupDuration = timeDifference - const Duration(minutes: Constant.meetingEndSoonTime);
    if (popupDuration > Duration.zero) {
      popupTimer?.cancel();
      popupTimer = Timer(popupDuration, () {
        if (_globalContext.mounted) {
          _showEndingSoonPopup();
        }
      });
    }

    // Schedule meeting end
    endMeetingTimer?.cancel();
    endMeetingTimer = Timer(timeDifference, () {
      _endMeeting();
    });
  }

  void _showEndingSoonPopup() {
    if (!_globalContext.mounted) return; // Prevent crashes

    showDialog(
      context: _globalContext,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text("Meeting Ending Soon"),
        content: Text(
          _canExtendMeeting()
              ? "The meeting will end in ${Constant.meetingEndSoonTime} minutes. You can extend it by ${Constant.meetingExtendTime} minutes."
              : "The meeting will end in ${Constant.meetingEndSoonTime} minutes.",
        ),
        actions: [
          if (_canExtendMeeting())
            TextButton(
              onPressed: () {
                endMeetingCallBack.call(MeetingExtends());
                extendMeetingBy10Minutes();
                Navigator.of(context).pop();
              },
              child: const Text("Extend"),
            ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text("Dismiss"),
          ),
        ],
      ),
    );
  }

  void extendMeetingBy10Minutes() {
    if (endDateTime == null) {
      debugPrint("Error: Cannot extend meeting. endDateTime is null.");
      return;
    }

    endDateTime = endDateTime!.add(const Duration(minutes: Constant.meetingExtendTime));
    debugPrint("Meeting extended by ${Constant.meetingExtendTime} minutes. New end time: $endDateTime");
    _scheduleTimers();
  }

  void _endMeeting() {
    endMeetingCallBack.call(MeetingEnd());
  }

  void cancelMeetingEndScheduler() {
    popupTimer?.cancel();
    endMeetingTimer?.cancel();
  }

  DateTime? _parseEndDate(String? endDate) {
    if (endDate == null || endDate.isEmpty) return null;

    try {
      return DateFormat("yyyy-MM-ddTHH:mm:ss.SSSZ").parse(endDate, true).toLocal();
    } catch (e) {
      debugPrint("Error parsing endDate: $e");
      return null;
    }
  }

  bool isMeetingEnded() {
    if (endDateTime == null) return false;
    return DateTime.now().isAfter(endDateTime!);
  }
}
