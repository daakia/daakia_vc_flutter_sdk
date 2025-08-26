class BaseListResponse<T> {
  int? success;
  String? message;
  List<T>? data;

  BaseListResponse({this.success, this.message, this.data});

  factory BaseListResponse.fromJson(
      Map<String, dynamic> json,
      T Function(dynamic) fromJsonT,
      ) {
    return BaseListResponse<T>(
      success: json['success'],
      message: json['message'],
      data: json['data'] != null
          ? (json['data'] as List<dynamic>)
          .map((item) => fromJsonT(item as Map<String, dynamic>))
          .toList()
          : null,
    );
  }
}
