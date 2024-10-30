class SendMessageModel {
  final String? id;
  final String? message;
  final int? timestamp; // Use int for compatibility with JSON serialization

  SendMessageModel({
    required this.id,
    required this.message,
    required this.timestamp,
  });

  // Factory constructor to create an instance from JSON
  factory SendMessageModel.fromJson(Map<String, dynamic> json) {
    return SendMessageModel(
      id: json['id'] as String?,
      message: json['message'] as String?,
      timestamp: json['timestamp'] as int?,
    );
  }

  // Method to convert instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'message': message,
      'timestamp': timestamp,
    };
  }
}
