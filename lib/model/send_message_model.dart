class SendMessageModel {
  final String? action;
  final String? id;
  final String? message;
  final int? timestamp;
  final bool? isReplied;
  // final String? replyMessage; // Field for the reply message, if any

  SendMessageModel({
    this.action,
    required this.id,
    required this.message,
    required this.timestamp,
    this.isReplied = false,
    // this.replyMessage,
  });

  // Factory constructor to create an instance from JSON
  factory SendMessageModel.fromJson(Map<String, dynamic> json) {
    return SendMessageModel(
      action: json['action'] as String?,
      id: json['id'] as String?,
      message: json['message'] as String?,
      timestamp: json['timestamp'] as int?,
      isReplied: json['isReplied'] as bool?,
      // replyMessage: json['replyMessage'] as String?,
    );
  }

  // Method to convert instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'action': action,
      'id': id,
      'message': message,
      'timestamp': timestamp,
      'isReplied': isReplied,
      // 'replyMessage': replyMessage,
    };
  }
}
