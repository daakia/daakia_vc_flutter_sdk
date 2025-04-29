class FeatureConfiguration {
  int? autoEndConference;
  String? brandingLogoUrl;
  String? brandingIconUrl;
  String? brandingAppTitle;
  int? brandingEnabled;
  String? askRecordingRequest;
  String? storageUnit;
  dynamic externalStorageUnitConfig;
  int? showMeetingInfo;
  int? allowMultipleCohost;
  int? enableReaction;
  int? enablePrivateChat;
  int? enableChat;
  int? allowProfileEditByHost;
  int? allowProfileEditBySelf;

  FeatureConfiguration({
    this.autoEndConference,
    this.brandingLogoUrl,
    this.brandingIconUrl,
    this.brandingAppTitle,
    this.brandingEnabled,
    this.askRecordingRequest,
    this.storageUnit,
    this.externalStorageUnitConfig,
    this.showMeetingInfo,
    this.allowMultipleCohost,
    this.enableReaction,
    this.enablePrivateChat,
    this.enableChat,
    this.allowProfileEditByHost,
    this.allowProfileEditBySelf,
  });

  FeatureConfiguration.fromJson(Map<String, dynamic> json) {
    autoEndConference = json['auto_end_conference'];
    brandingLogoUrl = json['branding_logo_url'];
    brandingIconUrl = json['branding_icon_url'];
    brandingAppTitle = json['branding_app_title'];
    brandingEnabled = json['branding_enabled'];
    askRecordingRequest = json['ask_recording_request'];
    storageUnit = json['storage_unit'];
    externalStorageUnitConfig = json['external_storage_unit_config'];
    showMeetingInfo = json['show_meeting_info'];
    allowMultipleCohost = json['allow_multiple_cohost'];
    enableReaction = json['enable_reaction'];
    enablePrivateChat = json['enable_private_chat'];
    enableChat = json['enable_chat'];
    allowProfileEditByHost = json['allow_profile_edit_by_host'];
    allowProfileEditBySelf = json['allow_profile_edit_by_self'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['auto_end_conference'] = autoEndConference;
    data['branding_logo_url'] = brandingLogoUrl;
    data['branding_icon_url'] = brandingIconUrl;
    data['branding_app_title'] = brandingAppTitle;
    data['branding_enabled'] = brandingEnabled;
    data['ask_recording_request'] = askRecordingRequest;
    data['storage_unit'] = storageUnit;
    data['external_storage_unit_config'] = externalStorageUnitConfig;
    data['show_meeting_info'] = showMeetingInfo;
    data['allow_multiple_cohost'] = allowMultipleCohost;
    data['enable_reaction'] = enableReaction;
    data['enable_private_chat'] = enablePrivateChat;
    data['enable_chat'] = enableChat;
    data['allow_profile_edit_by_host'] = allowProfileEditByHost;
    data['allow_profile_edit_by_self'] = allowProfileEditBySelf;
    return data;
  }
}
