class ConsentParticipant {
  final String? participantId;
  final String? participantName;
  final String? participantAvatar;
  final String? consent;

  ConsentParticipant({
    this.participantId,
    this.participantName,
    this.participantAvatar,
    this.consent,
  });

  factory ConsentParticipant.fromJson(Map<String, dynamic> json) {
    return ConsentParticipant(
      participantId: json['participantId'] as String?,
      participantName: json['participantName'] as String?,
      participantAvatar: json['participantAvatar'] as String?,
      consent: json['consent'] as String?,
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
