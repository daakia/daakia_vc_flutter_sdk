import 'package:daakia_vc_flutter_sdk/model/transcription_action_model.dart';
import 'package:livekit_client/livekit_client.dart';

class RemoteActivityData {
  final RemoteParticipant? identity;
  final String? id;
  final String? message;
  final int? timestamp;
  final String? action;
  final bool isSender;
  final String? requestId;
  final String? meetingUid;
  final String? displayName;
  final String? participantLobbyStatus;
  final String? token;
  final bool value;
  final String? userIdentity;
  final String? userName;
  final TranscriptionActionModel? liveCaptionsData;
  final String? partialTranscription;  // New field
  final String? finalTranscription;  // New field
  final String? participantIdentity;  // New field

  RemoteActivityData({
    this.identity,
    this.id,
    this.message,
    this.timestamp,
    this.action,
    this.isSender = false,
    this.requestId = "",
    this.meetingUid = "",
    this.displayName = "",
    this.participantLobbyStatus = "",
    this.token = "",
    this.value = false,
    this.userIdentity = "",
    this.userName = "",
    this.liveCaptionsData,
    this.partialTranscription,  // New field
    this.finalTranscription,  // New field
    this.participantIdentity,  // New field
  });

  // Factory constructor to create an instance from JSON
  factory RemoteActivityData.fromJson(Map<String, dynamic> json) {
    return RemoteActivityData(
      identity: json['identity'], // Handle RemoteParticipant parsing if needed
      id: json['id'] as String?,
      message: json['message'] as String?,
      timestamp: json['timestamp'] as int?,
      action: json['action'] as String?,
      isSender: json['isSender'] as bool? ?? false,
      requestId: json['request_id'] as String? ?? "",
      meetingUid: json['meeting_uid'] as String? ?? "",
      displayName: json['display_name'] as String? ?? "",
      participantLobbyStatus: json['participant_lobby_status'] as String? ?? "",
      token: json['token'] as String? ?? "",
      value: json['value'] as bool? ?? false,
      userIdentity: json['user_identity'] as String? ?? "",
      userName: json['user_name'] as String? ?? "",
      liveCaptionsData: json['liveCaptionsData'] != null
          ? TranscriptionActionModel.fromJson(json['liveCaptionsData'] as Map<String, dynamic>)
          : null,
      partialTranscription: json['partial'] as String?,  // New field
      finalTranscription: json['final'] as String?,  // New field
      participantIdentity: json['participant_identity'] as String?,  // New field
    );
  }

  // Method to convert instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'identity': identity,
      'id': id,
      'message': message,
      'timestamp': timestamp,
      'action': action,
      'isSender': isSender,
      'request_id': requestId,
      'meeting_uid': meetingUid,
      'display_name': displayName,
      'participant_lobby_status': participantLobbyStatus,
      'token': token,
      'value': value,
      'user_identity': userIdentity,
      'user_name': userName,
      'liveCaptionsData': liveCaptionsData,
      'partial': partialTranscription,  // New field
      'final': finalTranscription,  // New field
      'participant_identity': participantIdentity,  // New field
    };
  }

  copyWith(
      {RemoteParticipant? identity,
        String? id,
        String? message,
        int? timestamp,
        String? action,
        String? requestId,
        bool? isSender,
        String? meetingUid,
        String? displayName,
        String? participantLobbyStatus,
        String? token,
        bool? value,
        String? userIdentity,
        String? userName,
        TranscriptionActionModel? liveCaptionsData,
        String? partialTranscription,  // New field
        String? finalTranscription, // New field
        String? participantIdentity, // New field
      }) {
    return RemoteActivityData(
      identity: identity ?? this.identity,
      id: id ?? this.id,
      message: message ?? this.message,
      timestamp: timestamp ?? this.timestamp,
      action: action ?? this.action,
      requestId: requestId ?? this.requestId,
      isSender: isSender ?? this.isSender,
      meetingUid: meetingUid ?? this.meetingUid,
      displayName: displayName ?? this.displayName,
      participantLobbyStatus:
      participantLobbyStatus ?? this.participantLobbyStatus,
      token: token ?? token,
      value: value ?? this.value,
      userIdentity: userIdentity ?? this.userIdentity,
      userName: userName ?? this.userName,
      liveCaptionsData: liveCaptionsData ?? this.liveCaptionsData,
      partialTranscription: partialTranscription ?? this.partialTranscription,  // New field
      finalTranscription: finalTranscription ?? this.finalTranscription,  // New field
      participantIdentity: participantIdentity ?? this.participantIdentity,  // New field
    );
  }
}
