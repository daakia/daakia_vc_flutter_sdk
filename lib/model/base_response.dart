class BaseResponse<T> {
  int? success;
  String? message;
  T? data;

  BaseResponse({this.success, this.message, this.data});

  BaseResponse.fromJson(
      Map<String, dynamic> json, T Function(Map<String, dynamic>) fromJsonT) {
    success = json['success'];
    message = json['message'];

    if (json['data'] != null) {
      // Handle empty array or non-object data
      if (json['data'] is List && (json['data'] as List).isEmpty) {
        data = null; // Assign null if data is an empty array
      } else {
        data = fromJsonT(json['data']);
      }
    } else {
      data = null;
    }
  }

  Map<String, dynamic> toJson(Map<String, dynamic> Function(T) toJsonT) {
    final Map<String, dynamic> json = {};
    json['success'] = success;
    json['message'] = message;
    if (data != null) {
      json['data'] = toJsonT(data as T);
    } else {
      json['data'] = null; // Include null explicitly if data is empty
    }
    return json;
  }
}
