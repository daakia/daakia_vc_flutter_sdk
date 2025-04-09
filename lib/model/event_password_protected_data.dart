class EventPasswordProtectedData{
  bool? passwordVerified;

  EventPasswordProtectedData({this.passwordVerified});

  EventPasswordProtectedData.fromJson(Map<String, dynamic> json) {
    passwordVerified = json['password_verified'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['password_verified'] = passwordVerified;
    return data;
  }
}