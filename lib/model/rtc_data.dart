class RtcData {
  String? accessToken;
  String? meetingUid;
  String? livekitServerURL;
  String? roleName;
  bool? isHost;
  bool? participantCanJoin;
  bool? meetingStarted;
  bool? isRejected;
  String? requestId;

  RtcData(
      {accessToken,
        meetingUid,
        livekitServerURL,
        roleName,
        isHost,
        participantCanJoin,
        meetingStarted,
        isRejected,
        requestId});

  RtcData.fromJson(Map<String, dynamic> json) {
    accessToken = json['access_token'];
    meetingUid = json['meeting_uid'];
    livekitServerURL = json['livekit_server_URL'];
    roleName = json['role_name'];
    isHost = json['is_host'];
    participantCanJoin = json['participant_can_join'];
    meetingStarted = json['meeting_started'];
    isRejected = json['is_rejected'];
    requestId = json['request_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['access_token'] = accessToken;
    data['meeting_uid'] = meetingUid;
    data['livekit_server_URL'] = livekitServerURL;
    data['role_name'] = roleName;
    data['is_host'] = isHost;
    data['participant_can_join'] = participantCanJoin;
    data['meeting_started'] = meetingStarted;
    data['is_rejected'] = isRejected;
    data['request_id'] = requestId;
    return data;
  }
}