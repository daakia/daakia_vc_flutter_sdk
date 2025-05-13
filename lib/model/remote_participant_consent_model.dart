class RemoteParticipantConsent {
  String? participantId;
  String? participantName;
  String? participantAvatar;
  String? consent;

  RemoteParticipantConsent({
    this.participantId,
    this.participantName,
    this.participantAvatar,
    this.consent,
  });

  factory RemoteParticipantConsent.fromJson(Map<String, dynamic> json) {
    return RemoteParticipantConsent(
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
}
