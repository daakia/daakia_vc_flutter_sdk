class LiveKitData {
  String? accessToken;
  String? meetingUid;
  String? livekitServerURL;
  String? roleName;
  bool? isHost;
  bool? participantCanJoin;
  bool? meetingStarted;
  bool? isRejected;

  LiveKitData(
      {this.accessToken,
        this.meetingUid,
        this.livekitServerURL,
        this.roleName,
        this.isHost,
        this.participantCanJoin,
        this.meetingStarted,
        this.isRejected});

  LiveKitData.fromJson(Map<String, dynamic> json) {
    accessToken = json['access_token'];
    meetingUid = json['meeting_uid'];
    livekitServerURL = json['livekit_server_URL'];
    roleName = json['role_name'];
    isHost = json['is_host'];
    participantCanJoin = json['participant_can_join'];
    meetingStarted = json['meeting_started'];
    isRejected = json['is_rejected'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['access_token'] = this.accessToken;
    data['meeting_uid'] = this.meetingUid;
    data['livekit_server_URL'] = this.livekitServerURL;
    data['role_name'] = this.roleName;
    data['is_host'] = this.isHost;
    data['participant_can_join'] = this.participantCanJoin;
    data['meeting_started'] = this.meetingStarted;
    data['is_rejected'] = this.isRejected;
    return data;
  }
}