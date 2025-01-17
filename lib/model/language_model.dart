class LanguageModel {
  String? code;
  String? language;
  List<String>? support;

  LanguageModel({this.code, this.language, this.support});

  LanguageModel.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    language = json['language'];
    support = json['support'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['code'] = code;
    data['language'] = language;
    data['support'] = support;
    return data;
  }
}
