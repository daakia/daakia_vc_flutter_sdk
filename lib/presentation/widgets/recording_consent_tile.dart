import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../model/consent_participant.dart';
import '../../utils/consent_status_enum.dart';
import '../../viewmodel/rtc_viewmodel.dart';
import 'initials_circle.dart';

class RecordingConsentTile extends StatelessWidget {
  const RecordingConsentTile({super.key, required this.participant});

  final ConsentParticipant participant;

  @override
  Widget build(BuildContext context) {
    final ConsentStatus consentStatus = parseConsentStatus(participant.consent);
    final viewModel = Provider.of<RtcViewmodel>(context);
    return Container(
      color: Colors.transparent,
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Left: Initials Circle
          InitialsCircle(
            initials: participant.participantAvatar ?? "U",
          ),
          const SizedBox(width: 10),

          // Middle: Name and Status
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  participant.participantName ?? "Unknown",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    consentStatus.icon,
                    const SizedBox(width: 4),
                    Text(
                      consentStatus.label,
                      style: TextStyle(
                        color: consentStatus.labelColor,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Right: Resend Button if not accepted
          if (consentStatus.shouldShowResend)
            IconButton(
              onPressed: () {
                viewModel.resendRecordingConsent(participant.participantId);
              },
              icon: const Icon(Icons.refresh, color: Colors.blueAccent),
              tooltip: "Resend",
            ),
        ],
      ),
    );
  }
}
