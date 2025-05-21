import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:collection/collection.dart';
import 'package:daakia_vc_flutter_sdk/api/injection.dart';
import 'package:daakia_vc_flutter_sdk/events/rtc_events.dart';
import 'package:daakia_vc_flutter_sdk/model/consent_participant.dart';
import 'package:daakia_vc_flutter_sdk/model/participant_attendance_data.dart';
import 'package:daakia_vc_flutter_sdk/model/remote_activity_data.dart';
import 'package:daakia_vc_flutter_sdk/model/transcription_action_model.dart';
import 'package:daakia_vc_flutter_sdk/model/transcription_model.dart';
import 'package:daakia_vc_flutter_sdk/resources/json/language_json.dart';
import 'package:daakia_vc_flutter_sdk/utils/utils.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:livekit_client/livekit_client.dart';
import 'package:uuid/uuid.dart';

import '../model/action_model.dart';
import '../model/emoji_message.dart';
import '../model/language_model.dart';
import '../model/meeting_details.dart';
import '../model/private_chat_model.dart';
import '../model/send_message_model.dart';
import '../rtc/widgets/participant_info.dart';
import '../utils/consent_status_enum.dart';
import '../utils/meeting_actions.dart';

class RtcViewmodel extends ChangeNotifier {
  final List<RemoteActivityData> _messageList = [];
  final List<RemoteActivityData> _lobbyRequestList = [];
  final Map<String, PrivateChatModel> _privateChat = {};
  late Room room;
  late MeetingDetails meetingDetails;

  final List<ParticipantTrack> _participantTracks = [];

  final Map<String, bool> _raisedHandMap = {};

  bool _isMyHandRaised = false;

  bool isChatOpen = false;
  int _unreadMessageCount = 0;

  bool isPrivateChatOpen = false;
  int _unreadMessageCountPrivateChat = 0;

  bool _isCoHost = false;

  bool _isRecording = false;

  bool _isMeetingEnded = false;

  // Getter
  bool get isMeetingEnded => _isMeetingEnded;

// Setter
  set isMeetingEnded(bool value) {
    _isMeetingEnded = value;
    notifyListeners();
  }

  void setCoHost(bool isCoHost) {
    _isCoHost = isCoHost;
    notifyListeners();
  }

  bool getCoHost() => _isCoHost;

  int getUnReadCount() {
    return _unreadMessageCount;
  }

  void increaseUnreadCount() {
    if (isChatOpen) return;
    _unreadMessageCount++;
    notifyListeners();
  }

  void resetUnreadCount() {
    _unreadMessageCount = 0;
    notifyListeners();
  }

  int getUnreadCountPrivateChat() {
    return _unreadMessageCountPrivateChat;
  }

  void increaseUnreadPrivateChatCount() {
    if (isPrivateChatOpen) return;
    _unreadMessageCountPrivateChat++;
    notifyListeners();
  }

  void resetUnreadPrivateChatCount() {
    _unreadMessageCountPrivateChat = 0;
    notifyListeners();
  }

  RtcViewmodel(this.room, this.meetingDetails);

  List<RemoteActivityData> getMessageList() {
    return _messageList;
  }

  void addMessage(RemoteActivityData message) {
    _messageList.add(message);
    increaseUnreadCount();
    notifyListeners();
    sendPublicChatEvent(UpdateView());
  }

  void addAllMessage(List<RemoteActivityData> message) {
    _messageList.addAll(message);
    notifyListeners();
    sendPublicChatEvent(UpdateView());
  }

  void addPrivateMessage(RemoteActivityData message) {
    // Check if the key exists; if not, initialize it with an empty list
    if (message.identity != null) {
      checkAndCreatePrivateChat(
          message.identity?.identity, message.identity?.name);
      _privateChat[message.identity?.identity ?? ""]?.chats.add(message);
    } else {
      _privateChat.putIfAbsent(
          message.userIdentity ?? "",
          () => PrivateChatModel(
              identity: message.userIdentity ?? "Unknown",
              name: message.userName ?? "Unknown",
              chats: []));
      _privateChat[message.userIdentity ?? ""]?.chats.add(message);
    }
    notifyListeners();
    increaseUnreadPrivateChatCount();
    sendPrivateChatEvent(UpdateView());
  }

  void checkAndCreatePrivateChat(String? identity, String? name) {
    _privateChat.putIfAbsent(
        identity ?? "Unknown",
        () => PrivateChatModel(
            identity: identity ?? "Unknown",
            name: name ?? "Unknown",
            chats: []));
    notifyListeners();
    sendPrivateChatEvent(UpdateView());
  }

  Map<String, PrivateChatModel> getPrivateMessage() {
    return _privateChat;
  }

  List<RemoteActivityData> getPrivateChatForParticipant(String identity) {
    return _privateChat[identity]?.chats ?? [];
  }

  Future<void> sendPublicMessage(String userMessage) async {
    if (!Utils.isMessageSizeValid(userMessage)) {
      sendMessageToUI("Message is too long! Please shorten it and try again.");
      return;
    }
    // Create a message
    final message = SendMessageModel(
      action: MeetingActions.sendPublicMessage,
      id: const Uuid().v4(), // Generate a unique ID
      message: userMessage,
      timestamp: DateTime.now().millisecondsSinceEpoch, // Current timestamp
    );

    // Publish the data to the LiveKit room
    await room.localParticipant?.publishData(
      utf8.encode(jsonEncode(message)), // Convert to bytes,
      reliable: true,
    );

    // Update the message list
    addMessage(
      RemoteActivityData(
        identity: null,
        id: message.id,
        message: message.message,
        timestamp: message.timestamp,
        action: MeetingActions.sendPublicMessage,
        // Assuming no action is provided
        isSender: true, // isSender
      ),
    );
  }

  Future<void> sendPrivateMessage(
      String? identity, String? name, String userMessage) async {
    if (!Utils.isMessageSizeValid(userMessage)) {
      sendMessageToUI("Message is too long! Please shorten it and try again.");
      return;
    }
    // Create a message
    final message = SendMessageModel(
      action: MeetingActions.sendPrivateMessage,
      id: const Uuid().v4(), // Generate a unique ID
      message: userMessage,
      timestamp: DateTime.now().millisecondsSinceEpoch, // Current timestamp
    );

    if (identity != null) {
      List<String> participantList = [identity];
      try {
        // Publish the data to the LiveKit room
        await room.localParticipant?.publishData(
          utf8.encode(jsonEncode(message)), // Convert to bytes,
          reliable: true,
          destinationIdentities: participantList,
        );

        // Update the message list
        addPrivateMessage(
          RemoteActivityData(
              identity: null,
              id: message.id,
              message: message.message,
              timestamp: message.timestamp,
              action: MeetingActions.sendPrivateMessage,
              // Assuming no action is provided
              isSender: true,
              // isSender
              userIdentity: identity,
              userName: name),
        );
      } catch (e) {
        if (kDebugMode) {
          print('Error sending private action: $e');
        }
      }
    }
  }

  Future<void> sendPrivateAction(ActionModel action, String? identity) async {
    if (!MeetingActions.isValidAction(action.action)) {
      sendMessageToUI("Action not allowed.");
      return;
    }

    if (identity != null) {
      List<String> participantList = [identity];
      try {
        String jsonData = jsonEncode(action.toJson());
        await room.localParticipant?.publishData(
          utf8.encode(jsonData),
          reliable: true,
          destinationIdentities: participantList,
        );
      } catch (e) {
        if (kDebugMode) {
          print('Error sending private action: $e');
        }
      }
    }
  }

  Future<void> sendAction(ActionModel action) async {
    if (!MeetingActions.isValidAction(action.action)) {
      sendMessageToUI("Action not allowed.");
      return;
    }

    try {
      String jsonData = jsonEncode(action.toJson());
      await room.localParticipant?.publishData(
        utf8.encode(jsonData),
        reliable: true,
      );
      setHandRaisedForLocal(action);
    } catch (e) {
      if (kDebugMode) {
        print('Error sending action: $e');
      }
    }
  }

  void addParticipant(List<ParticipantTrack> participants) {
    // Clear the existing list
    _participantTracks.clear();

    // Create a map to store unique participants by identity
    final Map<String, ParticipantTrack> uniqueParticipants = {};

    for (var participantTrack in participants) {
      final identity = participantTrack.participant.identity;

      if (participantTrack.type == ParticipantTrackType.kScreenShare) {
        // If it's a screen share, update or add the entry
        uniqueParticipants[identity] = ParticipantTrack(
          participant: participantTrack.participant,
          type: ParticipantTrackType.kScreenShare,
        );
      } else {
        // If it's a user media track, add it only if no screen share exists for the participant
        uniqueParticipants.putIfAbsent(identity, () => participantTrack);
      }
    }

    // Sort participants to ensure local participant comes first
    ParticipantTrack? localParticipant =
        uniqueParticipants.values.firstWhereOrNull(
      (participantTrack) =>
          participantTrack.participant.identity ==
          room.localParticipant?.identity,
    );

    // Add local participant first if it exists
    if (localParticipant != null) {
      _participantTracks.add(localParticipant);
    }

    // Add the remaining participants excluding the local participant
    _participantTracks.addAll(
      uniqueParticipants.values.where(
        (participantTrack) =>
            participantTrack.participant.identity !=
            room.localParticipant?.identity,
      ),
    );

    updateIdentityToNameMap();
    requestForTranscriptionState();
    // Notify listeners of the update
    notifyListeners();
  }

  List<ParticipantTrack> getParticipantList() {
    return _participantTracks;
  }

  void addParticipantInLobby(RemoteActivityData participant) {
    _lobbyRequestList.add(participant);
  }

  List<RemoteActivityData> getLobbyRequestList() {
    return _lobbyRequestList;
  }

  //===========================RTC Controls====================

  bool _isAudioPermissionEnable = true;
  bool _isVideoPermissionEnable = true;
  double _micAlpha = 1.0;
  double _cameraAlpha = 1.0;

  LocalParticipant get participant => room.localParticipant!;

  void disableAudio() async {
    await participant.setMicrophoneEnabled(false);
    notifyListeners();
  }

  Future<void> enableAudio() async {
    await participant.setMicrophoneEnabled(true);
    notifyListeners();
  }

  void disableVideo() async {
    await participant.setCameraEnabled(false);
    notifyListeners();
  }

  void enableVideo() async {
    await participant.setCameraEnabled(true);
    notifyListeners();
  }

  void setMicAlpha(double alpha) {
    _micAlpha = alpha;
    notifyListeners();
  }

  double getMicAlpha() => _micAlpha;

  void setCameraAlpha(double alpha) {
    _cameraAlpha = alpha;
    notifyListeners();
  }

  double getCameraAlpha() => _cameraAlpha;

  bool isVisibleForHost(String role, String targetRole) {
    return role == "moderator";
  }

  bool isVisibleForCoHost(String role, String targetRole) {
    return role == "cohost" && targetRole != "moderator";
  }

  void removeFromCall(String identity) {
    Map<String, dynamic> body = {
      "participant_id": identity,
      "meeting_uid": meetingDetails.meetingUid
    };
    networkRequestHandler(
      apiCall: () =>
          apiClient.removeParticipant(meetingDetails.authorizationToken, body),
      onSuccess: (_) => sendMessageToUI("Participant Removed"),
      onError: (message) => sendMessageToUI(message),
    );
  }

  int _coHostCount = 0;

  // Getter
  int get coHostCount => _coHostCount;

// Setter
  set coHostCount(int value) {
    _coHostCount = value;
    notifyListeners();
  }

  void makeCoHost(String identity, bool isCoHost) {
    Map<String, dynamic> body = {
      "participant_identity": identity,
      "meeting_uid": meetingDetails.meetingUid,
      "is_co_host": isCoHost
    };
    networkRequestHandler(
      apiCall: () =>
          apiClient.makeCoHost(meetingDetails.authorizationToken, body),
      onSuccess: (_) => {
        sendPrivateAction(
            ActionModel(
                action: !isCoHost
                    ? MeetingActions.removeCoHost
                    : MeetingActions.makeCoHost,
                token: !isCoHost ? "" : meetingDetails.authorizationToken),
            identity),
        if (!meetingDetails.features!.isAllowMultipleCoHost())
          {
            if (isCoHost) {coHostCount++} else {coHostCount--}
          }
      },
      onError: (message) => sendMessageToUI(message),
    );
  }

  void setRecording(bool isRecording) {
    _isRecording = isRecording;
    notifyListeners();
  }

  bool get isRecording => _isRecording;

  void startRecording({bool isNeedToShowError = true}) {
    Map<String, dynamic> body = {
      "meeting_uid": meetingDetails.meetingUid,
    };
    networkRequestHandler(
      apiCall: () =>
          apiClient.startRecording(meetingDetails.authorizationToken, body),
      onSuccess: (_) {
        setRecording(true);
        sendMessageToUI("Recording Starting");
      },
      onError: (message) {
        if (isNeedToShowError) {
          sendMessageToUI(message);
        }
      },
    );
  }

  void stopRecording() {
    Map<String, dynamic> body = {
      "meeting_uid": meetingDetails.meetingUid,
    };
    networkRequestHandler(
      apiCall: () =>
          apiClient.stopRecording(meetingDetails.authorizationToken, body),
      onSuccess: (_) {
        setRecording(false);
        sendMessageToUI("Recording Stop");
        try {
          meetingDetails
              .meetingBasicDetails?.meetingConfig?.recordingForceStopped = 1;
        } catch (_) {}
      },
      onError: (message) => sendMessageToUI(message),
    );
  }

  bool isHost() {
    return Utils.isHost(room.localParticipant?.metadata);
  }

  bool isCoHost() {
    return Utils.isCoHost(room.localParticipant?.metadata);
  }

  bool isHandRaised(String identity) {
    var isHandRaised = _raisedHandMap[identity] ?? false;
    return isHandRaised;
  }

  void setHandRaised(RemoteActivityData remoteData) {
    _raisedHandMap[remoteData.identity?.identity ?? ""] =
        (remoteData.action == "raise_hand");
    notifyListeners();
  }

  void stopHandRaisedForAll() {
    _raisedHandMap.clear();
    _isMyHandRaised = false;
    notifyListeners();
  }

  void setMyHandRaised(bool isHandRaised) {
    _isMyHandRaised = isHandRaised;
    notifyListeners();
  }

  bool get isMyHandRaised => _isMyHandRaised;

  void setHandRaisedForLocal(ActionModel action) {
    _raisedHandMap[room.localParticipant?.identity ?? ""] =
        (action.action == MeetingActions.raiseHand);
    notifyListeners();
  }

  set isAudioPermissionEnable(bool isAudioPermissionEnable) {
    _isAudioPermissionEnable = isAudioPermissionEnable;
    notifyListeners();
  }

  set isVideoPermissionEnable(bool isVideoPermissionEnable) {
    _isVideoPermissionEnable = isVideoPermissionEnable;
    notifyListeners();
  }

  bool get isAudioPermissionEnable => _isAudioPermissionEnable;

  bool get isVideoPermissionEnable => _isVideoPermissionEnable;

  bool _isWebinarModeEnable = false;
  bool _isAudioModeEnable = false;
  bool _isVideoModeEnable = false;

// Getter and Setter for _isWebinarModeEnable
  bool get isWebinarModeEnable => _isWebinarModeEnable;

  set isWebinarModeEnable(bool value) {
    _isWebinarModeEnable = value;
    _isAudioModeEnable = value;
    _isVideoModeEnable = value;
    notifyListeners();
    sendAction(ActionModel(action: MeetingActions.forceMuteAll, value: value));
    sendAction(
        ActionModel(action: MeetingActions.forceVideoOffAll, value: value));
  }

// Getter and Setter for _isAudioModeEnable
  bool get isAudioModeEnable => _isAudioModeEnable;

  set isAudioModeEnable(bool value) {
    _isAudioModeEnable = value;
    _isWebinarModeEnable = (_isAudioModeEnable && _isVideoModeEnable);
    sendAction(ActionModel(action: MeetingActions.forceMuteAll, value: value));
    notifyListeners();
  }

// Getter and Setter for _isVideoModeEnable
  bool get isVideoModeEnable => _isVideoModeEnable;

  set isVideoModeEnable(bool value) {
    _isVideoModeEnable = value;
    _isWebinarModeEnable = (_isAudioModeEnable && _isVideoModeEnable);
    sendAction(
        ActionModel(action: MeetingActions.forceVideoOffAll, value: value));
    notifyListeners();
  }

  void acceptParticipant(
      {required RemoteActivityData? request,
      required bool accept,
      bool acceptAll = false}) {
    if (request == null) return;
    Map<String, dynamic> body = {
      "meeting_uid": meetingDetails.meetingUid,
    };
    if (!acceptAll) {
      body["request_id"] = request.requestId;
      body["is_admit"] = accept;
    } else {
      body["is_admit_all"] = acceptAll;
    }
    networkRequestHandler(
        apiCall: () => apiClient.acceptParticipantInLobby(body),
        onSuccess: (_) {
          if (accept) {
            sendMessageToUI("Participant accepted");
          } else {
            sendMessageToUI("Participant rejected");
          }
        },
        onError: (message) => sendMessageToUI(message));
  }

  final Map<String, int> requestTimestamps = {};
  final Set<String> _previousLobbyRequestList = {};
  Timer? _timer;

  List<RemoteActivityData> get lobbyRequestList =>
      List.unmodifiable(_lobbyRequestList);

  void checkAndAddUserToLobbyList(RemoteActivityData remoteData) {
    final requestId = remoteData.requestId ?? "";

    if (!_previousLobbyRequestList.contains(requestId)) {
      _lobbyRequestList.add(remoteData);
      _previousLobbyRequestList.add(requestId);
      requestTimestamps[requestId] = DateTime.now().millisecondsSinceEpoch;
      notifyListeners();
    } else {
      // Update the timestamp for the existing request
      requestTimestamps[requestId] = DateTime.now().millisecondsSinceEpoch;
    }
  }

  void startLobbyCheck() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 2), (timer) {
      final currentTime = DateTime.now().millisecondsSinceEpoch;

      // Remove entries older than 12 seconds without `removeWhere`
      List<String> toRemove = [];
      requestTimestamps.forEach((requestId, timestamp) {
        if (currentTime - timestamp > 12000) {
          toRemove.add(requestId);
        }
      });

      for (final requestId in toRemove) {
        requestTimestamps.remove(requestId);
        _previousLobbyRequestList.remove(requestId);
        _lobbyRequestList.removeWhere((data) => data.requestId == requestId);
      }

      startReactionCheck();

      if (toRemove.isNotEmpty) {
        notifyListeners();
      }
    });
  }

  void stopLobbyCheck() {
    _timer?.cancel();
  }

  final _roomEventController = StreamController<RTCEvents>();

  // Stream to expose the events
  Stream<RTCEvents> get roomEvents => _roomEventController.stream;

  final _publicChatEventController = StreamController<RTCEvents>.broadcast();
  final _privateChatEventController = StreamController<RTCEvents>.broadcast();

  final _uploadAttachmentController = StreamController<RTCEvents>.broadcast();

  final _mainChatController = StreamController<RTCEvents>.broadcast();

  // Expose streams
  Stream<RTCEvents> get publicChatEvents => _publicChatEventController.stream;

  Stream<RTCEvents> get privateChatEvents => _privateChatEventController.stream;

  Stream<RTCEvents> get uploadAttachmentController =>
      _uploadAttachmentController.stream;

  Stream<RTCEvents> get mainChatController => _mainChatController.stream;

  // Send events
  void sendPublicChatEvent(RTCEvents event) {
    if (_publicChatEventController.isClosed) return;
    _publicChatEventController.sink.add(event);
  }

  void sendPrivateChatEvent(RTCEvents event) {
    if (_privateChatEventController.isClosed) return;
    _privateChatEventController.sink.add(event);
  }

  void sendUploadAttachmentEvent(RTCEvents event) {
    if (_uploadAttachmentController.isClosed) return;
    _uploadAttachmentController.sink.add(event);
  }

  void sendMainChatControllerEvent(RTCEvents event) {
    if (_mainChatController.isClosed) return;
    _mainChatController.sink.add(event);
  }

  // Cancel chat event streams
  void cancelPublicChatEvents() {
    _publicChatEventController.close();
  }

  void cancelPrivateChatEvents() {
    _privateChatEventController.close();
  }

  void cancelUploadAttachmentEvent() {
    _uploadAttachmentController.close();
  }

  void cancelMainChatControllerEvent() {
    _mainChatController.close();
  }

  void cancelRoomEvents() {
    _roomEventController.close();
  }

  // Function to emit events
  void sendEvent(RTCEvents event) {
    _roomEventController.sink.add(event);
  }

  // Function to show a snackbar message
  void sendMessageToUI(String? message) {
    sendEvent(ShowSnackBar(message ?? ""));
  }

  final List<EmojiMessage> _emojiQueue = [];

  void addEmoji(EmojiMessage emoji) {
    _emojiQueue.add(emoji);
    if (emojiQueue.length > 6) {
      emojiQueue.removeAt(0);
    }
    notifyListeners(); // Notify listeners to update the UI
  }

  void removeEmojiAt(int position) {
    _emojiQueue.removeAt(position);
    notifyListeners();
  }

  List<EmojiMessage> get emojiQueue => _emojiQueue;

  void startReactionCheck() {
    final currentTime = DateTime.now().millisecondsSinceEpoch;
    // Remove emojis older than 3 seconds
    _emojiQueue.removeWhere(
      (emoji) => currentTime - int.parse(emoji.timestamp) > 3000,
    );
    notifyListeners();
    sendEvent(UpdateView());
  }

  var _privateChatIdentity = "";

  void setPrivateChatIdentity(String identity) {
    _privateChatIdentity = identity;
    notifyListeners();
    sendPrivateChatEvent(UpdateView());
  }

  String getPrivateChatIdentity() {
    return _privateChatIdentity;
  }

  var _privateChatUserName = "";

  void setPrivateChatUserName(String name) {
    _privateChatUserName = name;
    notifyListeners();
    sendPrivateChatEvent(UpdateView());
  }

  String getPrivateChatUserName() {
    return _privateChatUserName;
  }

  BuildContext? context;

  void uploadAttachment(File file, Function? onUploadSuccess) {
    networkRequestHandler(
        apiCall: () =>
            apiClient.uploadFile(file, onSendProgress: (sent, total) {
              publicMessageProgress = sent / total;
              sendUploadAttachmentEvent(ShowProgress(publicMessageProgress));
            }),
        onSuccess: (data) {
          if (onUploadSuccess != null) {
            onUploadSuccess();
          }
          resetProgress();
          sendPublicMessage(data?.url ?? "");
        });
  }

  void uploadPrivateAttachment(
      String identity, String name, File file, Function? onUploadSuccess) {
    networkRequestHandler(
        apiCall: () =>
            apiClient.uploadFile(file, onSendProgress: (sent, total) {
              privateMessageProgress = sent / total;
              sendUploadAttachmentEvent(ShowProgress(privateMessageProgress));
            }),
        onSuccess: (data) {
          if (onUploadSuccess != null) {
            onUploadSuccess();
          }
          resetProgress();
          sendPrivateMessage(identity, name, data?.url ?? "");
        });
  }

  double _publicMessageProgress = -1;
  double _privateMessageProgress = -1;

  // Getter for public message upload progress
  double get publicMessageProgress => _publicMessageProgress;

  // Setter for public message upload progress
  set publicMessageProgress(double progress) {
    _publicMessageProgress = progress;
    notifyListeners(); // Notify UI updates
  }

  // Getter for private message upload progress
  double get privateMessageProgress => _privateMessageProgress;

  // Setter for private message upload progress
  set privateMessageProgress(double progress) {
    _privateMessageProgress = progress;
    notifyListeners(); // Notify UI updates
  }

  // Reset progress for both messages
  void resetProgress() {
    _publicMessageProgress = -1;
    _privateMessageProgress = -1;
    notifyListeners();
  }

  //================Transcription=============

  TranscriptionModel? particalTranscription;
  List<TranscriptionModel> _transcriptionList = [];

  // Getter
  List<TranscriptionModel> get transcriptionList => _transcriptionList;

  // Setter
  set transcriptionList(List<TranscriptionModel> value) {
    _transcriptionList = value;
    notifyListeners();
  }

  void addTranscription(TranscriptionModel value) {
    _transcriptionList.add(value);
    notifyListeners();
  }

  bool _isTranscriptionLanguageSelected = false;

  set isTranscriptionLanguageSelected(bool isSelected) {
    _isTranscriptionLanguageSelected = isSelected;
    notifyListeners();
  }

  bool get isTranscriptionLanguageSelected => _isTranscriptionLanguageSelected;

  List<LanguageModel> _languages = [];

  // Getter
  List<LanguageModel> get languages => _languages;

  // Setter
  set languages(List<LanguageModel> value) {
    _languages = value;
    notifyListeners();
  }

  Future<List<LanguageModel>> fetchLanguages() async {
    // 1. Load the JSON string from the assets folder
    const String response = languageJsonString;

    // 2. Check for loading errors (optional, but good practice)
    if (response.isEmpty) {
      throw Exception('Error loading JSON file');
    }

    // 3. Decode the JSON string into a Dart object
    final data = await json.decode(response) as List<
        dynamic>; // Cast to List<dynamic> to avoid potential type errors

    // 4. Convert each JSON object to a LanguageModel instance
    return data.map((item) => LanguageModel.fromJson(item)).toList();
  }

  void setTranscriptionLanguage(
      LanguageModel selectedLanguage, Function transcriptionEnabled) {
    Map<String, dynamic> body = {
      "meeting_uid": meetingDetails.meetingUid,
      "transcription_enable": true,
      "transcription_lang_iso": selectedLanguage.code,
      "transcription_lang_title": selectedLanguage.code
    };
    networkRequestHandler(
        apiCall: () => apiClient.setTranscriptionLanguage(
            meetingDetails.authorizationToken, body),
        onSuccess: (data) {
          isTranscriptionLanguageSelected = true;
          sendAction(ActionModel(
              action: MeetingActions.showLiveCaption,
              liveCaptionsData: TranscriptionActionModel(
                  showIcon: true,
                  isLanguageSelected: true,
                  langCode: selectedLanguage.code,
                  sourceLang: selectedLanguage.code)));
          transcriptionEnabled.call();
        },
        onError: (message) => sendMessageToUI(message));
  }

  void startTranscription() {
    Map<String, dynamic> body = {
      "meeting_uid": meetingDetails.meetingUid,
    };
    networkRequestHandler(apiCall: () => apiClient.startTranscription(body));
  }

  TranscriptionActionModel? _transcriptionLanguageData;

  TranscriptionActionModel? get transcriptionLanguageData =>
      _transcriptionLanguageData;

  // Setter method to set the value of _transcriptionLanguageData
  set transcriptionLanguageData(TranscriptionActionModel? value) {
    if (value != null) {
      value.sourceLang ??= value.langCode;
    }
    _transcriptionLanguageData = value;
    notifyListeners();
  }

  void saveTranscriptionLanguage(TranscriptionActionModel? liveCaptionsData) {
    if (liveCaptionsData == null) return;
    isTranscriptionLanguageSelected =
        liveCaptionsData.isLanguageSelected ?? false;
    transcriptionLanguageData = liveCaptionsData;
  }

  void collectTranscriptionData(RemoteActivityData remoteData) {
    // Check if the incoming data is a final transcription
    if (remoteData.finalTranscription?.isNotEmpty == true) {
      // If there's an existing partial transcription, finalize it
      if (particalTranscription != null) {
        particalTranscription = particalTranscription!.copyWith(
            name: getParticipantNameByIdentity(remoteData.participantIdentity),
            transcription: Utils.decodeUnicode(remoteData.finalTranscription),
            isFinal: true,
            sourceLang: transcriptionLanguageData?.sourceLang,
            targetLang: translationLanguage?.code ??
                transcriptionLanguageData?.sourceLang);

        // Replace the existing transcription in the list with the finalized one
        _updateTranscriptionInList(particalTranscription!);

        // Trigger translation if source and target languages differ
        if (particalTranscription?.sourceLang !=
            particalTranscription?.targetLang) {
          translateText(particalTranscription!);
        }
      } else {
        // Create and add a new finalized transcription
        final newTranscription = TranscriptionModel(
          id: const Uuid().v4(),
          name: getParticipantNameByIdentity(remoteData.participantIdentity),
          transcription: Utils.decodeUnicode(remoteData.finalTranscription),
          timestamp: Utils.formatTimestampToTime(
              DateTime.now().millisecondsSinceEpoch),
          isFinal: true,
          sourceLang: transcriptionLanguageData?.sourceLang ?? "",
          targetLang: translationLanguage?.code ??
              (transcriptionLanguageData?.sourceLang ?? ""),
        );
        addTranscription(newTranscription);

        // Trigger translation if source and target languages differ
        if (newTranscription.sourceLang != newTranscription.targetLang) {
          translateText(newTranscription);
        }
      }

      // Reset the partial transcription
      particalTranscription = null;
    } else if (remoteData.partialTranscription?.isNotEmpty == true) {
      // Handle partial transcription updates
      if (particalTranscription != null) {
        // Update the existing partial transcription
        particalTranscription = particalTranscription!.copyWith(
            name: getParticipantNameByIdentity(remoteData.participantIdentity),
            transcription: remoteData.partialTranscription ?? "",
            isFinal: false,
            sourceLang: transcriptionLanguageData?.sourceLang,
            targetLang: translationLanguage?.code ??
                transcriptionLanguageData?.sourceLang);

        // Update the transcription in the list
        _updateTranscriptionInList(particalTranscription!);
      } else {
        // Create and add a new partial transcription
        particalTranscription = TranscriptionModel(
          id: const Uuid().v4(),
          name: getParticipantNameByIdentity(remoteData.participantIdentity),
          transcription: remoteData.partialTranscription ?? "",
          timestamp: Utils.formatTimestampToTime(
              DateTime.now().millisecondsSinceEpoch),
          isFinal: false,
          sourceLang: transcriptionLanguageData?.sourceLang ?? "",
          targetLang: translationLanguage?.code ??
              (transcriptionLanguageData?.sourceLang ?? ""),
        );
        addTranscription(particalTranscription!);
      }
    }
  }

  void _updateTranscriptionInList(TranscriptionModel updatedModel) {
    final index = _transcriptionList.indexWhere((t) => t.id == updatedModel.id);
    if (index != -1) {
      _transcriptionList[index] = updatedModel;
    } else {
      _transcriptionList
          .add(updatedModel); // Add if it doesn't exist (fallback)
    }
    notifyListeners();
  }

  final Map<String, String> _identityToNameMap = {};

  void updateIdentityToNameMap() {
    _identityToNameMap.clear();
    for (final track in _participantTracks) {
      final identity = track.participant.identity;
      final name = track.participant.name;
      _identityToNameMap[identity] = name;
    }
  }

  String getParticipantNameByIdentity(String? identity) {
    if (identity == null) return "Unknown";
    return _identityToNameMap[identity] ?? "Unknown";
  }

  var _isRequestedForTranscription = false;

  void requestForTranscriptionState() {
    if (_isRequestedForTranscription) return;
    _isRequestedForTranscription = true;
    if (meetingDetails.meetingBasicDetails?.transcriptionDetail != null) {
      if (meetingDetails
              .meetingBasicDetails?.transcriptionDetail?.transcriptionEnable ==
          true) {
        var data = meetingDetails.meetingBasicDetails?.transcriptionDetail;
        isTranscriptionLanguageSelected = true;
        transcriptionLanguageData = TranscriptionActionModel(
            showIcon: data?.transcriptionEnable,
            isLanguageSelected: data?.transcriptionEnable,
            langCode: data?.transcriptionLangIso,
            sourceLang: data?.transcriptionLangIso);
        return;
      }
    }
    // Skip the first participant (alias "you") and check the others
    for (int i = 1; i < _participantTracks.length; i++) {
      var participantTrack = _participantTracks[i];
      var participant = participantTrack.participant;
      if (!Utils.isHost(participant.metadata) &&
          !Utils.isCoHost(participant.metadata)) {
        // Send the action with the participant's ID (assuming `identity` is the ID)
        sendPrivateAction(
          ActionModel(action: MeetingActions.requestLiveCaptionDrawerState),
          participant.identity, // Using participant's identity (ID)
        );
        break; // Exit after sending the action to the first valid participant
      }
    }
  }

  void checkTranscriptionStateAndReturn(RemoteActivityData remoteData) {
    if (_transcriptionLanguageData != null) {
      if (_transcriptionLanguageData?.isLanguageSelected == true) {
        sendPrivateAction(
            ActionModel(
                action: MeetingActions.showLiveCaption,
                liveCaptionsData: TranscriptionActionModel(
                    showIcon: true,
                    isLanguageSelected: true,
                    langCode: _transcriptionLanguageData?.langCode,
                    sourceLang: _transcriptionLanguageData?.sourceLang)),
            remoteData.participantIdentity);
      }
    }
  }

  LanguageModel? _translationLanguage;

  LanguageModel? get translationLanguage => _translationLanguage;

  set translationLanguage(LanguageModel? language) {
    _translationLanguage = language;
    notifyListeners();
  }

  void translateText(TranscriptionModel transcriptionData,
      {Function? callBack}) {
    Map<String, dynamic> body = {
      "meeting_uid": meetingDetails.meetingUid,
      "source_language": transcriptionData.sourceLang,
      "target_language": translationLanguage?.code,
      "text": transcriptionData.transcription,
    };
    networkRequestHandler(
        apiCall: () => apiClient.translateText(body),
        onSuccess: (data) {
          _updateTranscriptionInList(transcriptionData.copyWith(
            translatedTranscription: data?.translatedText,
            targetLang: translationLanguage?.code,
          ));
          callBack?.call();
        },
        onError: (message) {
          callBack?.call();
          sendMessageToUI(message);
        });
  }

  void endMeetingForAll() {
    Map<String, dynamic> body = {
      "meeting_uid": meetingDetails.meetingUid,
    };
    networkRequestHandler(
      apiCall: () => apiClient.endMeeting(body),
      onSuccess: (_) => sendEvent(EndMeeting()),
      onError: (message) => sendMessageToUI(message),
    );
  }

  void updateParticipantName({String? participant, required String newName}) {
    if (participant == null) return;
    Map<String, dynamic> body = {
      "meeting_uid": meetingDetails.meetingUid,
      "participant_identity": participant,
      "new_name": newName,
    };
    networkRequestHandler(
        apiCall: () => apiClient.updateParticipantName(body),
        onError: (message) => sendMessageToUI(message));
  }

  void configAutoRecording() {
    if (isHost()) {
      if (meetingDetails.meetingBasicDetails?.meetingConfig != null) {
        var meetingConfig = meetingDetails.meetingBasicDetails?.meetingConfig!;
        if (meetingConfig?.recordingForceStopped != 1 &&
            meetingConfig?.autoStartRecording == 1) {
          if (!isRecording) {
            startRecording(isNeedToShowError: false);
          }
        }
      }
    }
  }

  void meetingTimeExtend() {
    Map<String, dynamic> body = {
      "meeting_uid": meetingDetails.meetingUid,
      "is_extend_time": true,
    };
    networkRequestHandler(
        apiCall: () => apiClient.meetingTimeExtend(
            meetingDetails.authorizationToken, body),
        onSuccess: (_) => sendAction(
            ActionModel(action: MeetingActions.extendMeetingEndTime)));
  }

  bool isAutoMeetingEndEnable() {
    if (isHost() &&
        meetingDetails.meetingBasicDetails?.meetingConfig?.autoMeetingEnd ==
            1) {
      return true;
    }
    return false;
  }

  String? getMeetingEndDate() {
    return meetingDetails
            .meetingBasicDetails?.meetingConfig?.autoMeetingEndSchedule ??
        meetingDetails.meetingBasicDetails?.endDate;
  }

  void getWhiteboardData() {
    networkListRequestHandler(
        apiCall: () => apiClient.getWhiteBoardData(
            meetingDetails.meetingBasicDetails?.meetingId.toString() ?? ""),
        onSuccess: (data) {
          final whiteboard = data!.first;
          sendEvent(WhiteboardStatus(status: whiteboard.status == 'open'));
        });
  }

  List<ParticipantAttendanceData> _pendingParticipantList = [];

  // Getter
  List<ParticipantAttendanceData> get pendingParticipantList =>
      _pendingParticipantList;

  // Setter
  set pendingParticipantList(List<ParticipantAttendanceData> newList) {
    _pendingParticipantList = newList;
    notifyListeners();
  }

  Timer? _attendanceDebounceTimer;

  void getAttendanceListForParticipant() {
    if (!isHost() && !isCoHost()) {
      return;
    }
    // Cancel any existing timer
    _attendanceDebounceTimer?.cancel();

    // Start a new debounce timer
    _attendanceDebounceTimer = Timer(const Duration(seconds: 1), () {
      networkListRequestHandler(
          apiCall: () => apiClient
              .getAttendanceListForParticipant(meetingDetails.meetingUid),
          onSuccess: (data) {
            collectInactiveParticipant(data);
          });
    });
  }

  void collectInactiveParticipant(List<ParticipantAttendanceData>? data) {
    List<ParticipantAttendanceData> tempList = [];
    if (data != null) {
      for (var participant in data) {
        if (participant.participantStatus?.toLowerCase() != 'joined') {
          tempList.add(participant);
        }
      }
    }
    pendingParticipantList = tempList;
  }

  //Recording Consent Flow

  List<ConsentParticipant> _participantListForConsent = [];

  List<ConsentParticipant> get participantListForConsent =>
      _participantListForConsent;

  set participantListForConsent(List<ConsentParticipant> list) {
    _participantListForConsent = list;
    notifyListeners();
  }

  void updateRecordingConsentStatus(bool status) {
    var metadata = room.localParticipant?.metadata;
    Map<String, dynamic> body = {
      "meeting_uid": meetingDetails.meetingUid,
      "session_id": getSessionId(),
      "is_accepted": status,
      "attendance_id": Utils.getMetadataAttendanceId(metadata),
    };

    networkRequestHandler(
        apiCall: () => apiClient.updateRecordingConsent(body),
        onSuccess: (data) {
          if (data?.canStartRecording == true) {
            startRecording();
          }
          sendAction(ActionModel(
              action: MeetingActions.recordingConsentStatus,
              consent: status ? "accept" : "reject"));
        },
        onError: (message) {
          sendMessageToUI(message);
        });
  }

  void startRecordingConsentFlow() {
    if (isRecording) {
      stopRecording();
    } else {
      checkSessionStatus();
    }
  }

  var sessionId = "";

  String? getSessionId() {
    if (sessionId.isNotEmpty) {
      return sessionId;
    }

    final metadataSessionId =
        Utils.getMetadataSessionUid(room.localParticipant?.metadata);
    if (metadataSessionId.isNotEmpty && metadataSessionId != "null") {
      return metadataSessionId;
    }

    return meetingDetails.meetingBasicDetails?.currentSessionUid;
  }

  void checkSessionStatus({bool asUser = false, Function? callBack}) {
    networkRequestHandler(
        apiCall: () => apiClient.getSessionDetails(meetingDetails.meetingUid),
        onSuccess: (data) {
          if (data != null) {
            sessionId = data.id.toString();
          }

          if (data?.recordingConsentActive == 1) {
            if (asUser) {
              // Fetch consent list before checking consent
              getParticipantConsentList(onLoaded: () {
                if (!hasAlreadyAcceptedConsent()) {
                  callBack?.call(); // Show dialog if not yet accepted
                }
              });
            } else {
              getParticipantConsentList();
            }
          } else {
            if (!asUser) {
              startRecordingConsent();
            }
          }
        },
        onError: (message) {
          sendMessageToUI(message);
        }
    );
  }

  void startRecordingConsent() {
    var metadata = room.localParticipant?.metadata;
    Map<String, dynamic> body = {
      "meeting_uid": meetingDetails.meetingUid,
      "session_id": getSessionId(),
      "meeting_consent_start": true,
      "attendance_id": Utils.getMetadataAttendanceId(metadata),
    };
    networkRequestHandler(
        apiCall: () => apiClient.startRecordingConsent(body),
        onSuccess: (_) {
          sendAction(ActionModel(
              action: MeetingActions.recordingConsentModal, value: true));
          getParticipantConsentList();
        },
        onError: (message) {
          sendMessageToUI(message);
        });
  }

  void getParticipantConsentList({VoidCallback? onLoaded}) {
    networkListRequestHandler(
        apiCall: () => apiClient.getParticipantConsentList(
            meetingDetails.meetingUid, getSessionId() ?? ""),
        onSuccess: (data) {
          if (data != null) {
            final localList = ConsentParticipant.fromRemoteList(data);
            participantListForConsent = localList;

            if(onLoaded != null){
              onLoaded.call(); // <-- Trigger callback after loading list
              return;
            }
            sendAction(ActionModel(
              action: MeetingActions.startedRecordingConsent,
              participants: localList,
            ));

          }
        }
    );
  }


  void verifyRecordingConsent(RemoteActivityData remoteData) {
    if (!isHost() && !isCoHost()) return;

    if (participantListForConsent.isEmpty) {
      getParticipantConsentList();
      return;
    }

    int index = participantListForConsent.indexWhere(
      (participant) =>
          participant.participantId == remoteData.identity?.identity,
    );

    if (index != -1) {
      final existing = participantListForConsent[index];
      participantListForConsent[index] = ConsentParticipant(
        participantId: existing.participantId,
        participantName: existing.participantName,
        participantAvatar: existing.participantAvatar,
        consent: remoteData.consent,
      );
    }
    notifyListeners();
  }

  bool hasAlreadyAcceptedConsent() {
    final participant = room.localParticipant;
    final localId = participant?.identity;
    final existing = participantListForConsent.firstWhere(
      (p) => p.participantId == localId,
      orElse: () => ConsentParticipant(
        participantId: localId ?? '',
        participantName: participant?.name,
        participantAvatar: Utils.getInitials(participant?.name),
        consent: null,
      ),
    );

    return parseConsentStatus(existing.consent) == ConsentStatus.accept;
  }

  void resendRecordingConsent(String? identity) {
    sendPrivateAction(
        ActionModel(action: MeetingActions.recordingConsentModal, value: true),
        identity);
  }

  void addParticipantToConsentList(RemoteParticipant participant) {
    if ((!isHost() && !isCoHost()) &&
        !meetingDetails.features!.isRecordingConsentAllowed()) {
      return;
    }

    final participantId = participant.identity;

    // Check for duplicates
    final alreadyExists = participantListForConsent.any(
      (p) => p.participantId == participantId,
    );

    if (alreadyExists) return;

    // Add new participant to the list
    final newConsentParticipant =
        ConsentParticipant.fromRemoteParticipant(participant);

    participantListForConsent.add(newConsentParticipant);
    notifyListeners();
  }

  void removeParticipantFromConsentList(String participantId) {
    participantListForConsent.removeWhere(
      (participant) => participant.participantId == participantId,
    );
    notifyListeners();
  }
}
