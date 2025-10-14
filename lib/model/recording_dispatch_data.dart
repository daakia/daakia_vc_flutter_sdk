class RecordingDispatchData {
  final String dispatchId;

  RecordingDispatchData({
    required this.dispatchId,
  });

  factory RecordingDispatchData.fromJson(Map<String, dynamic> json) {
    return RecordingDispatchData(
      dispatchId: json['recording_dispatch_id'],
    );
  }

  Map<String, dynamic> toJson() => {'recording_dispatch_id': dispatchId};
}
