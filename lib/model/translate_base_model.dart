class TranslateBaseModel {
  String? status;
  String? code;
  String? message;
  Meta? meta;
  Data? data;

  TranslateBaseModel(
      {this.status, this.code, this.message, this.meta, this.data});

  TranslateBaseModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    code = json['code'];
    message = json['message'];
    meta = json['meta'] != null ? Meta.fromJson(json['meta']) : null;
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['code'] = code;
    data['message'] = message;
    if (meta != null) {
      data['meta'] = meta!.toJson();
    }
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Meta {
  int? totalCharCount;

  Meta({this.totalCharCount});

  Meta.fromJson(Map<String, dynamic> json) {
    totalCharCount = json['total_char_count'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['total_char_count'] = totalCharCount;
    return data;
  }
}

class Data {
  String? translatedText;
  String? detectedSourceLanguage;

  Data({this.translatedText, this.detectedSourceLanguage});

  Data.fromJson(Map<String, dynamic> json) {
    translatedText = json['translatedText'];
    detectedSourceLanguage = json['detectedSourceLanguage'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['translatedText'] = translatedText;
    data['detectedSourceLanguage'] = detectedSourceLanguage;
    return data;
  }
}
