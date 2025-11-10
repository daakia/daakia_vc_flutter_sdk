class ScreenShareConsentModel {
  bool screenShareConsent = false;

  ScreenShareConsentModel({required this.screenShareConsent});

  factory ScreenShareConsentModel.fromJson(Map<String, dynamic> json) {
    return ScreenShareConsentModel(
      screenShareConsent: json['screen_share_consent'],
    );
  }

  Map<String, dynamic> toJson() => {
        'screen_share_consent': screenShareConsent,
      };
}
