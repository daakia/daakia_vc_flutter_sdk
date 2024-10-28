class Features {
  int? id;
  int? subscriptionId;
  int? isActive;
  String? audioVideoConference;
  String? meetDuration;
  String? cloudStorage;
  int? saveCloud;
  int? internationalPhone;
  int? hostMeetingMobile;
  int? conferenceChat;
  int? whiteboard;
  int? noiseCancellation;
  int? recordMeeting;
  int? poll;
  int? raiseHand;
  int? breakoutRoom;
  int? screenSharing;
  int? voiceTranscription;
  int? voiceTextTranslation;
  int? liveStream;
  int? shareYoutube;
  int? trackAttendance;
  int? muteParticipant;
  int? disableCamera;
  int? compatibility;
  int? mobileSupport;
  int? encryption;
  int? lobby;
  int? protectedMeeting;
  int? spamProtection;
  int? translation;
  int? videoTranslation;
  int? isBasic;

  Features(
      {this.id,
      this.subscriptionId,
      this.isActive,
      this.audioVideoConference,
      this.meetDuration,
      this.cloudStorage,
      this.saveCloud,
      this.internationalPhone,
      this.hostMeetingMobile,
      this.conferenceChat,
      this.whiteboard,
      this.noiseCancellation,
      this.recordMeeting,
      this.poll,
      this.raiseHand,
      this.breakoutRoom,
      this.screenSharing,
      this.voiceTranscription,
      this.voiceTextTranslation,
      this.liveStream,
      this.shareYoutube,
      this.trackAttendance,
      this.muteParticipant,
      this.disableCamera,
      this.compatibility,
      this.mobileSupport,
      this.encryption,
      this.lobby,
      this.protectedMeeting,
      this.spamProtection,
      this.translation,
      this.videoTranslation,
      this.isBasic});

  Features.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    subscriptionId = json['subscription_id'];
    isActive = json['is_active'];
    audioVideoConference = json['audio_video_conference'];
    meetDuration = json['meet_duration'];
    cloudStorage = json['cloud_storage'];
    saveCloud = json['save_cloud'];
    internationalPhone = json['international_phone'];
    hostMeetingMobile = json['host_meeting_mobile'];
    conferenceChat = json['conference_chat'];
    whiteboard = json['whiteboard'];
    noiseCancellation = json['noise_cancellation'];
    recordMeeting = json['record_meeting'];
    poll = json['poll'];
    raiseHand = json['raise_hand'];
    breakoutRoom = json['breakout_room'];
    screenSharing = json['screen_sharing'];
    voiceTranscription = json['voice_transcription'];
    voiceTextTranslation = json['voice_text_translation'];
    liveStream = json['live_stream'];
    shareYoutube = json['share_youtube'];
    trackAttendance = json['track_attendance'];
    muteParticipant = json['mute_participant'];
    disableCamera = json['disable_camera'];
    compatibility = json['compatibility'];
    mobileSupport = json['mobile_support'];
    encryption = json['encryption'];
    lobby = json['lobby'];
    protectedMeeting = json['protected_meeting'];
    spamProtection = json['spam_protection'];
    translation = json['translation'];
    videoTranslation = json['video_translation'];
    isBasic = json['is_basic'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['subscription_id'] = this.subscriptionId;
    data['is_active'] = this.isActive;
    data['audio_video_conference'] = this.audioVideoConference;
    data['meet_duration'] = this.meetDuration;
    data['cloud_storage'] = this.cloudStorage;
    data['save_cloud'] = this.saveCloud;
    data['international_phone'] = this.internationalPhone;
    data['host_meeting_mobile'] = this.hostMeetingMobile;
    data['conference_chat'] = this.conferenceChat;
    data['whiteboard'] = this.whiteboard;
    data['noise_cancellation'] = this.noiseCancellation;
    data['record_meeting'] = this.recordMeeting;
    data['poll'] = this.poll;
    data['raise_hand'] = this.raiseHand;
    data['breakout_room'] = this.breakoutRoom;
    data['screen_sharing'] = this.screenSharing;
    data['voice_transcription'] = this.voiceTranscription;
    data['voice_text_translation'] = this.voiceTextTranslation;
    data['live_stream'] = this.liveStream;
    data['share_youtube'] = this.shareYoutube;
    data['track_attendance'] = this.trackAttendance;
    data['mute_participant'] = this.muteParticipant;
    data['disable_camera'] = this.disableCamera;
    data['compatibility'] = this.compatibility;
    data['mobile_support'] = this.mobileSupport;
    data['encryption'] = this.encryption;
    data['lobby'] = this.lobby;
    data['protected_meeting'] = this.protectedMeeting;
    data['spam_protection'] = this.spamProtection;
    data['translation'] = this.translation;
    data['video_translation'] = this.videoTranslation;
    data['is_basic'] = this.isBasic;
    return data;
  }
}
