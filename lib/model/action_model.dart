import 'package:daakia_vc_flutter_sdk/model/transcription_action_model.dart';

class ActionModel {
  final String? action;
  final String? message;
  final String? token;
  final bool value;
  final TranscriptionActionModel? liveCaptionsData;
  final String? consent;

  ActionModel({
    this.action,
    this.message = "",
    this.token = "",
    this.value = true,
    this.liveCaptionsData,
    this.consent,
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
    );
  }
}
