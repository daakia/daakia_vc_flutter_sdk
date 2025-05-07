class ParticipantAttendanceData {
  String? identifier;
  int? sessionId;
  String? screenName;
  String? email;
  String? role;
  String? participantStatus;

  ParticipantAttendanceData(
      {this.identifier,
      this.sessionId,
      this.screenName,
      this.email,
      this.role,
      this.participantStatus});

  ParticipantAttendanceData.fromJson(Map<String, dynamic> json) {
    identifier = json['identifier'];
    sessionId = json['session_id'];
    screenName = json['screen_name'];
    email = json['email'];
    role = json['role'];
    participantStatus = json['participant_status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['identifier'] = identifier;
    data['session_id'] = sessionId;
    data['screen_name'] = screenName;
    data['email'] = email;
    data['role'] = role;
    data['participant_status'] = participantStatus;
    return data;
  }
}
