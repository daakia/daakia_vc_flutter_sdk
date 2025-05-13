class RemoteParticipantConsent {
  String? screenName;
  String? rtcParticipantUid;
  String? role;
  String? recordingConsentStatus;

  RemoteParticipantConsent({
    this.screenName,
    this.rtcParticipantUid,
    this.role,
    this.recordingConsentStatus,
  });

  factory RemoteParticipantConsent.fromJson(Map<String, dynamic> json) {
    return RemoteParticipantConsent(
      screenName: json['screen_name'],
      rtcParticipantUid: json['rtc_participant_uid'],
      role: json['role'],
      recordingConsentStatus: json['recording_consent_status'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'screen_name': screenName,
      'rtc_participant_uid': rtcParticipantUid,
      'role': role,
      'recording_consent_status': recordingConsentStatus,
    };
  }
}
