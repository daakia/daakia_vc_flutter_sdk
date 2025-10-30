import 'package:daakia_vc_flutter_sdk/model/reply_message.dart';
import 'package:daakia_vc_flutter_sdk/model/transcription_action_model.dart';
import 'package:livekit_client/livekit_client.dart';

import 'consent_participant.dart';

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
  final String? partialTranscription;
  final String? finalTranscription;
  final String? participantIdentity;
  final int? whiteboardId;
  final String? consent;
  final List<ConsentParticipant>? participants;
  final String? dispatchId;
  final String? mode;
  final bool isDeleted;
  final ReplyMessage? replyMessage;

  // ✅ ADD NEW FIELD

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
    this.partialTranscription,
    this.finalTranscription,
    this.participantIdentity,
    this.whiteboardId,
    this.consent,
    this.participants,
    this.dispatchId,
    this.mode,
    this.isDeleted = false,
    this.replyMessage,
    // ✅ ADD NEW FIELD
  });

  factory RemoteActivityData.fromJson(Map<String, dynamic> json) {
    return RemoteActivityData(
      identity: json['identity'],
      // If needed, parse manually
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
          ? TranscriptionActionModel.fromJson(
              json['liveCaptionsData'] as Map<String, dynamic>)
          : null,
      partialTranscription: json['partial'] as String?,
      finalTranscription: json['final'] as String?,
      participantIdentity: json['participant_identity'] as String?,
      whiteboardId: json['whiteboardId'] as int?,
      consent: json['consent'] as String?,
      participants: (json['participants'] as List<dynamic>?)
          ?.map((e) => ConsentParticipant.fromJson(e as Map<String, dynamic>))
          .toList(),
      dispatchId: json['dispatchId'] as String?,
      mode: json['mode'] as String?,
      isDeleted: json['isDeleted'] as bool? ?? false,
      replyMessage: json['replyMessage'] != null
          ? ReplyMessage.fromJson(json['replyMessage'] as Map<String, dynamic>)
          : null,
      // ✅ ADD NEW FIELD
    );
  }

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
      'liveCaptionsData': liveCaptionsData?.toJson(),
      'partial': partialTranscription,
      'final': finalTranscription,
      'participant_identity': participantIdentity,
      'whiteboardId': whiteboardId,
      'consent': consent,
      'participants': participants?.map((e) => e.toJson()).toList(),
      'dispatchId': dispatchId,
      'mode': mode,
      'isDeleted': isDeleted,
      'replyMessage': replyMessage,
      // ✅ ADD NEW FIELD
    };
  }

  RemoteActivityData copyWith({
    RemoteParticipant? identity,
    String? id,
    String? message,
    int? timestamp,
    String? action,
    bool? isSender,
    String? requestId,
    String? meetingUid,
    String? displayName,
    String? participantLobbyStatus,
    String? token,
    bool? value,
    String? userIdentity,
    String? userName,
    TranscriptionActionModel? liveCaptionsData,
    String? partialTranscription,
    String? finalTranscription,
    String? participantIdentity,
    int? whiteboardId,
    String? consent,
    List<ConsentParticipant>? participants,
    String? dispatchId,
    String? mode,
    bool? isDeleted,
    ReplyMessage? replyMessage,
    // ✅ ADD NEW FIELD
  }) {
    return RemoteActivityData(
      identity: identity ?? this.identity,
      id: id ?? this.id,
      message: message ?? this.message,
      timestamp: timestamp ?? this.timestamp,
      action: action ?? this.action,
      isSender: isSender ?? this.isSender,
      requestId: requestId ?? this.requestId,
      meetingUid: meetingUid ?? this.meetingUid,
      displayName: displayName ?? this.displayName,
      participantLobbyStatus:
          participantLobbyStatus ?? this.participantLobbyStatus,
      token: token ?? this.token,
      value: value ?? this.value,
      userIdentity: userIdentity ?? this.userIdentity,
      userName: userName ?? this.userName,
      liveCaptionsData: liveCaptionsData ?? this.liveCaptionsData,
      partialTranscription: partialTranscription ?? this.partialTranscription,
      finalTranscription: finalTranscription ?? this.finalTranscription,
      participantIdentity: participantIdentity ?? this.participantIdentity,
      whiteboardId: whiteboardId ?? this.whiteboardId,
      consent: consent ?? this.consent,
      participants: participants ?? this.participants,
      dispatchId: dispatchId ?? this.dispatchId,
      mode: mode ?? this.mode,
      isDeleted: isDeleted ?? this.isDeleted,
      replyMessage: replyMessage ?? this.replyMessage,
      // ✅ ADD NEW FIELD
    );
  }
}
