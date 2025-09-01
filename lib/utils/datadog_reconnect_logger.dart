import 'dart:convert';

import 'package:daakia_vc_flutter_sdk/service/daakia_vc_datadog_service.dart';
import 'package:daakia_vc_flutter_sdk/utils/device_network_info.dart';
import 'package:flutter/foundation.dart';
import 'package:livekit_client/livekit_client.dart';

class DatadogReconnectLogger {
  static Future<void> logReconnectEvent({
    required String meetingId,
    required Room room,
    required String state, // "attempt", "reconnected", "disconnected"
    int? attempt,
    int? maxAttempts,
    int? delayMs,
  }) async {
    final local = room.localParticipant;

    Map<String, dynamic> metadataJson = {};
    try {
      if (local?.metadata != null) {
        metadataJson = Map<String, dynamic>.from(
          jsonDecode(local!.metadata!),
        );
      }
    } catch (_) {
      // Ignore metadata parsing errors
    }

    final attributes = <String, Object?>{
      'meetingId': meetingId,
      'state': state,
      if (attempt != null) 'attempt': attempt,
      if (maxAttempts != null) 'maxAttempts': maxAttempts,
      if (delayMs != null) 'nextRetryDelayMs': delayMs,
      'participantAttendanceId': metadataJson['meeting_attendance_id'],
      'participant': {
        'name': local?.name,
        'identity': local?.identity,
        'metadata': local?.metadata,
        'role': metadataJson['role_name'],
        'meetingAttendanceId': metadataJson['meeting_attendance_id'],
        'connectionQuality': local?.connectionQuality.name,
        'isSpeaking': local?.isSpeaking,
        'platform': defaultTargetPlatform.name,
        'userAgent': await DeviceNetworkInfo.getDeviceDetails(),
        'network': await DeviceNetworkInfo.getNetworkType()
      }
    };
    DaakiaVcDatadogService.logError(
      'Reconnecting to the room!!!',
      null,
      null,
      attributes,
    );
  }
}
