class TranslationData {
  String? translatedText;

  TranslationData({this.translatedText});

  TranslationData.fromJson(Map<String, dynamic> json) {
    translatedText = json['translatedText'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['translatedText'] = translatedText;
    return data;
  }
}