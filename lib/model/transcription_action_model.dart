class TranscriptionActionModel {
  bool? showIcon;
  bool? isLanguageSelected;
  String? langCode;
  String? sourceLang;

  TranscriptionActionModel(
      {this.showIcon, this.isLanguageSelected, this.langCode, this.sourceLang});

  TranscriptionActionModel.fromJson(Map<String, dynamic> json) {
    showIcon = json['showIcon'];
    isLanguageSelected = json['isLanguageSelected'];
    langCode = json['langCode'];
    sourceLang = json['source_lang'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['showIcon'] = showIcon;
    data['isLanguageSelected'] = isLanguageSelected;
    data['langCode'] = langCode;
    data['source_lang'] = sourceLang;
    return data;
  }
}
