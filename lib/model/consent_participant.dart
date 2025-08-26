import 'package:daakia_vc_flutter_sdk/model/remote_participant_consent_model.dart';
import 'package:livekit_client/livekit_client.dart';

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
    final Map<String, RemoteParticipantConsent> uidToParticipant = {};

    for (var remote in remoteList) {
      final uid = remote.rtcParticipantUid;
      if (uid != null) {
        // Always keep the latest one — this will overwrite any earlier entry
        uidToParticipant[uid] = remote;
      }
    }

    return uidToParticipant.values
        .map((remote) => ConsentParticipant.fromRemote(remote))
        .toList(); // final list will have latest entries at the end
  }

  factory ConsentParticipant.fromRemoteParticipant(RemoteParticipant remote) {
    return ConsentParticipant(
      participantName: remote.name,
      participantId: remote.identity,
      participantAvatar: Utils.getInitials(remote.name),
      // default or mapped
      consent: "pending",
    );
  }

  ConsentParticipant copyWith({
    String? participantId,
    String? participantName,
    String? participantAvatar,
    String? consent,
  }) {
    return ConsentParticipant(
      participantId: participantId ?? this.participantId,
      participantName: participantName ?? this.participantName,
      participantAvatar: participantAvatar ?? this.participantAvatar,
      consent: consent ?? this.consent,
    );
  }

}
