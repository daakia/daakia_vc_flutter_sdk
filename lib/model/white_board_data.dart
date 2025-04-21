class WhiteboardData {
  int? id;
  String? status;
  String? url;
  List<dynamic>? data;

  WhiteboardData({this.id, this.status, this.url, this.data});

  factory WhiteboardData.fromJson(Map<String, dynamic> json) {
    return WhiteboardData(
      id: json['id'],
      status: json['status'],
      url: json['url'],
      data: json['data'] ?? [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'status': status,
      'url': url,
      'data': data,
    };
  }
}
