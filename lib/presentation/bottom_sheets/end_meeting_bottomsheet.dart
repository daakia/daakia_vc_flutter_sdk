import 'package:flutter/material.dart';

import '../../resources/colors/color.dart';

class EndMeetingBottomSheet extends StatefulWidget {
  final VoidCallback onEndCall;
  final VoidCallback onLeaveCall;

  const EndMeetingBottomSheet(
      {required this.onEndCall, required this.onLeaveCall, super.key});

  @override
  State<EndMeetingBottomSheet> createState() => _EndMeetingBottomSheetState();
}

class _EndMeetingBottomSheetState extends State<EndMeetingBottomSheet> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.maxFinite,
      padding: const EdgeInsets.all(16.0),
      decoration: const BoxDecoration(
        color: emptyVideoColor,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16.0),
          topRight: Radius.circular(16.0),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: double.infinity,
            height: 60, // Square shape (height equal to width of the button)
            child: ElevatedButton(
              onPressed: widget.onEndCall,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16.0), // Rounded corners
                ),
              ),
              child: const Text(
                "End Call",
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          const SizedBox(height: 10),
          SizedBox(
            width: double.infinity,
            height: 60, // Square shape
            child: ElevatedButton(
              onPressed: widget.onLeaveCall,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.grey,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16.0), // Rounded corners
                ),
              ),
              child: const Text(
                "Leave Call",
                style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
