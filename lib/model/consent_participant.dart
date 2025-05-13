import 'package:daakia_vc_flutter_sdk/model/remote_participant_consent_model.dart';

import '../utils/utils.dart';

class ConsentParticipant {
  String? participantId;
  String? participantName;
  String? participantAvatar;
  String? consent;

  ConsentParticipant({
    this.participantId,
    this.participantName,
    this.participantAvatar,
    this.consent,
  });

  factory ConsentParticipant.fromJson(Map<String, dynamic> json) {
    return ConsentParticipant(
      participantId: json['participantId'],
      participantName: json['participantName'],
      participantAvatar: json['participantAvatar'],
      consent: json['consent'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'participantId': participantId,
      'participantName': participantName,
      'participantAvatar': participantAvatar,
      'consent': consent,
    };
  }

  factory ConsentParticipant.fromRemote(RemoteParticipantConsent remote) {
    return ConsentParticipant(
      participantName: remote.screenName,
      participantId: remote.rtcParticipantUid,
      participantAvatar: Utils.getInitials(remote.screenName),
      // default or mapped
      consent: remote.recordingConsentStatus ?? "pending",
    );
  }

  static List<ConsentParticipant> fromRemoteList(
      List<RemoteParticipantConsent> remoteList) {
    return remoteList
        .map((remote) => ConsentParticipant.fromRemote(remote))
        .toList();
  }
}
