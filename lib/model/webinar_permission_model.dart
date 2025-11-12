class WebinarPermissionModel {
  bool videoPermission = false;
  bool audioPermission = false;

  WebinarPermissionModel({required this.videoPermission, required this.audioPermission});

  factory WebinarPermissionModel.fromJson(Map<String, dynamic> json) {
    return WebinarPermissionModel(
      videoPermission: json['video_permission'],
      audioPermission: json['audio_permission'],
    );
  }

  Map<String, dynamic> toJson() => {
    'video_permission': videoPermission,
    'audio_permission': audioPermission,
  };
}