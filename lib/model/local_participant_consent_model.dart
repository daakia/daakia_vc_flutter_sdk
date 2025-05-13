import 'package:daakia_vc_flutter_sdk/model/remote_participant_consent_model.dart';
import 'package:daakia_vc_flutter_sdk/utils/utils.dart';

class LocalParticipantConsent {
  String? participantId;
  String? participantName;
  String? participantAvatar;
  String? consent;

  LocalParticipantConsent({
    this.participantId,
    this.participantName,
    this.participantAvatar,
    this.consent,
  });

  factory LocalParticipantConsent.fromJson(Map<String, dynamic> json) {
    return LocalParticipantConsent(
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

  factory LocalParticipantConsent.fromRemote(RemoteParticipantConsent remote) {
    return LocalParticipantConsent(
      participantName: remote.screenName,
      participantId: remote.rtcParticipantUid,
      participantAvatar: Utils.getInitials(remote.screenName),
      // default or mapped
      consent: remote.recordingConsentStatus ?? "pending",
    );
  }

  static List<LocalParticipantConsent> fromRemoteList(
      List<RemoteParticipantConsent> remoteList) {
    return remoteList
        .map((remote) => LocalParticipantConsent.fromRemote(remote))
        .toList();
  }
}
