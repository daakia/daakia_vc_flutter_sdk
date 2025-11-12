class WebinarPermissionModel {
  bool? videoPermission;
  bool? audioPermission;

  WebinarPermissionModel({this.videoPermission, this.audioPermission});

  factory WebinarPermissionModel.fromJson(Map<String, dynamic> json) {
    return WebinarPermissionModel(
      videoPermission: json['video_permission'] as bool?,
      audioPermission: json['audio_permission'] as bool?,
    );
  }

  Map<String, dynamic> toJson() => {
    if (videoPermission != null) 'video_permission': videoPermission,
    if (audioPermission != null) 'audio_permission': audioPermission,
  };
}