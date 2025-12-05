class ReplyMessage {
  final String name;
  final String message;
  final String id;
  final String identity;

  ReplyMessage({
    required this.name,
    required this.message,
    required this.id,
    required this.identity,
  });

  factory ReplyMessage.fromJson(Map<String, dynamic> json) {
    return ReplyMessage(
      name: json['name'] ?? '',
      message: json['message'] ?? '',
      id: json['id'] ?? '',
      identity: json['identity'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'message': message,
      'id': id,
      'identity': identity,
    };
  }
}
