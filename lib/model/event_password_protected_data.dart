class EventPasswordProtectedData{
  bool? passwordVerified;
  String? participantEmail;

  EventPasswordProtectedData({this.passwordVerified, this.participantEmail});

  EventPasswordProtectedData.fromJson(Map<String, dynamic> json) {
    passwordVerified = json['password_verified'];
    participantEmail = json['participant_email'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['password_verified'] = passwordVerified;
    data['participant_email'] = participantEmail;
    return data;
  }
}