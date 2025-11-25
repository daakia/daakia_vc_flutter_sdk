class CaptionData {
  final String text;
  final String speechEventType; // "interim_transcript" or "final_transcript"
  final String participantIdentity;
  final String language;
  final double confidence;

  CaptionData({
    required this.text,
    required this.speechEventType,
    required this.participantIdentity,
    required this.language,
    required this.confidence,
  });

  factory CaptionData.fromJson(Map<String, dynamic> json) {
    return CaptionData(
      text: json['text'] ?? "",
      speechEventType: json['speechEventType'] ?? "",
      participantIdentity: json['participantIdentity'] ?? "",
      language: json['language'] ?? "",
      confidence: (json['confidence'] as num?)?.toDouble() ?? 0.0,
    );
  }
}
