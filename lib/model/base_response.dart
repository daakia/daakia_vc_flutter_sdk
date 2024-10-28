class BaseResponse<T> {
  int? success;
  String? message;
  T? data;

  BaseResponse({this.success, this.message, this.data});

  BaseResponse.fromJson(Map<String, dynamic> json, T Function(Map<String, dynamic>) fromJsonT) {
    success = json['success'];
    message = json['message'];
    data = json['data'] != null ? fromJsonT(json['data']) : null;
  }

  Map<String, dynamic> toJson(Map<String, dynamic> Function(T) toJsonT) {
    final Map<String, dynamic> json = {};
    json['success'] = success;
    json['message'] = message;
    if (data != null) {
      json['data'] = toJsonT(data!);
    }
    return json;
  }
}
