import 'package:daakia_vc_flutter_sdk/model/transcription_action_model.dart';

import 'consent_participant.dart';

class ActionModel {
  final String? action;
  final String? message;
  final String? token;
  final bool value;
  final TranscriptionActionModel? liveCaptionsData;
  final String? consent;
  final List<ConsentParticipant>? participants;
  final Map<String, dynamic>? user;
  final int? timeStamp;
  final String? dispatchId;
  final String? id;
  final String? mode;

  // ✅ ADD NEW FIELD

  ActionModel({
    this.action,
    this.message = "",
    this.token = "",
    this.value = true,
    this.liveCaptionsData,
    this.consent,
    this.participants,
    this.user,
    this.timeStamp,
    this.dispatchId,
    this.id,
    this.mode,
    // ✅ ADD NEW FIELD
  });

  // Converts ActionModel to JSON
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      'action': action,
      'message': message,
      'token': token,
      'value': value,
    };
    if (liveCaptionsData != null) {
      data['liveCaptionsData'] = liveCaptionsData;
    }
    if (consent != null) {
      data['consent'] = consent;
    }
    if (participants != null) {
      data['participants'] = participants!.map((p) => p.toJson()).toList();
    }
    if (user != null) {
      data['user'] = user;
    }
    if (timeStamp != null) {
      data['timeStamp'] = timeStamp;
    }
    if (dispatchId != null) {
      data['dispatchId'] = dispatchId;
    }
    if (id != null) {
      data['id'] = id;
    }
    if (mode != null) {
      data['mode'] = mode;
    }
    // ✅ ADD NEW FIELD
    return data;
  }

  // Creates an ActionModel from JSON
  factory ActionModel.fromJson(Map<String, dynamic> json) {
    return ActionModel(
      action: json['action'] as String?,
      message: json['message'] as String? ?? "",
      token: json['token'] as String? ?? "",
      value: json['value'] as bool? ?? true,
      liveCaptionsData: json['liveCaptionsData'] as TranscriptionActionModel?,
      consent: json['consent'] as String?,
      participants: (json['participants'] as List<dynamic>?)
          ?.map((e) => ConsentParticipant.fromJson(e as Map<String, dynamic>))
          .toList(),
      user: json['user'] as Map<String, dynamic>?,
      timeStamp: json['timeStamp'] as int?,
      dispatchId: json['dispatchId'] as String? ?? "",
      id: json['id'] as String? ?? "",
      mode: json['mode'] as String? ?? "",
      // ✅ ADD NEW FIELD
    );
  }
}
