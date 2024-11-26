import 'dart:async';
import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:daakia_vc_flutter_sdk/api/injection.dart';
import 'package:daakia_vc_flutter_sdk/events/rtc_events.dart';
import 'package:daakia_vc_flutter_sdk/model/remote_activity_data.dart';
import 'package:daakia_vc_flutter_sdk/utils/utils.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:livekit_client/livekit_client.dart';
import 'package:uuid/uuid.dart';

import '../model/action_model.dart';
import '../model/emoji_message.dart';
import '../model/meeting_details.dart';
import '../model/private_chat_model.dart';
import '../model/send_message_model.dart';
import '../rtc/widgets/participant_info.dart';

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

  bool _isCoHost = false;

  bool _isRecording = false;

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

  RtcViewmodel(this.room, this.meetingDetails);

  List<RemoteActivityData> getMessageList() {
    return _messageList;
  }

  void addMessage(RemoteActivityData message) {
    _messageList.add(message);
    increaseUnreadCount();
    notifyListeners();
  }

  void addAllMessage(List<RemoteActivityData> message) {
    _messageList.addAll(message);
    notifyListeners();
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
    sendEvent(UpdateView());
  }

  void checkAndCreatePrivateChat(String? identity, String? name) {
    _privateChat.putIfAbsent(
        identity ?? "Unknown",
        () => PrivateChatModel(
            identity: identity ?? "Unknown",
            name: name ?? "Unknown",
            chats: []));
    notifyListeners();
    sendEvent(UpdateView());
  }

  Map<String, PrivateChatModel> getPrivateMessage() {
    return _privateChat;
  }

  List<RemoteActivityData> getPrivateChatForParticipant(String identity) {
    return _privateChat[identity]?.chats ?? [];
  }

  Future<void> sendPublicMessage(String userMessage) async {
    // Create a message
    final message = SendMessageModel(
      action: "send_public_message",
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
        action: "send_public_message",
        // Assuming no action is provided
        isSender: true, // isSender
      ),
    );
  }

  Future<void> sendPrivateMessage(
      String? identity, String? name, String userMessage) async {
    // Create a message
    final message = SendMessageModel(
      action: "send_private_message",
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
              action: "send_private_message",
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

    // Try to find the local participant based on identity
    ParticipantTrack? localParticipant = participants.firstWhereOrNull(
      (participant) =>
          participant.participant.identity == room.localParticipant?.identity,
    );

    // Add the local participant first if it exists
    if (localParticipant != null) {
      _participantTracks.add(localParticipant);
    }

    // Add remaining participants, excluding the local participant if it exists
    _participantTracks.addAll(
      participants.where((participant) =>
          participant.participant.identity != room.localParticipant?.identity),
    );

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
      "meeting_uid": meetingDetails.meeting_uid
    };
    apiClient
        .removeParticipant(meetingDetails.authorization_token, body)
        .then((response) {
      if (response.success == 1) {
        sendMessageToUI("Participant Removed");
      } else {
        sendMessageToUI(response.message ?? "Something went wrong!");
      }
    });
  }

  void makeCoHost(String identity, bool isCoHost) {
    Map<String, dynamic> body = {
      "participant_identity": identity,
      "meeting_uid": meetingDetails.meeting_uid,
      "is_co_host": isCoHost
    };
    apiClient
        .makeCoHost(meetingDetails.authorization_token, body)
        .then((response) {
      if (response.success == 1) {
        sendPrivateAction(
            ActionModel(
                action: "makeCoHost",
                token: meetingDetails.authorization_token),
            identity);
      } else {
        sendMessageToUI(response.message ?? "Something went wrong!");
      }
    });
  }

  void setRecording(bool isRecording) {
    _isRecording = isRecording;
    notifyListeners();
  }

  bool get isRecording => _isRecording;

  void startRecording() {
    Map<String, dynamic> body = {
      "meeting_uid": meetingDetails.meeting_uid,
    };
    apiClient
        .startRecording(meetingDetails.authorization_token, body)
        .then((response) {
      if (response.success == 1) {
        setRecording(true);
        sendMessageToUI("Recording Starting");
      } else {
        sendMessageToUI(response.message ?? "Something went wrong!");
      }
    });
  }

  void stopRecording() {
    Map<String, dynamic> body = {
      "meeting_uid": meetingDetails.meeting_uid,
    };
    apiClient
        .stopRecording(meetingDetails.authorization_token, body)
        .then((response) {
      if (response.success == 1) {
        setRecording(false);
        sendMessageToUI("Recording Stop");
      } else {
        sendMessageToUI(response.message ?? "Something went wrong!");
      }
    });
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
        (action.action == "raise_hand");
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
    sendAction(ActionModel(action: "force_mute_all", value: value));
    sendAction(ActionModel(action: "force_video_off_all", value: value));
  }

// Getter and Setter for _isAudioModeEnable
  bool get isAudioModeEnable => _isAudioModeEnable;

  set isAudioModeEnable(bool value) {
    _isAudioModeEnable = value;
    _isWebinarModeEnable = (_isAudioModeEnable && _isVideoModeEnable);
    sendAction(ActionModel(action: "force_mute_all", value: value));
    notifyListeners();
  }

// Getter and Setter for _isVideoModeEnable
  bool get isVideoModeEnable => _isVideoModeEnable;

  set isVideoModeEnable(bool value) {
    _isVideoModeEnable = value;
    _isWebinarModeEnable = (_isAudioModeEnable && _isVideoModeEnable);
    sendAction(ActionModel(action: "force_video_off_all", value: value));
    notifyListeners();
  }

  void acceptParticipant(
      {required RemoteActivityData? request,
      required bool accept,
      bool acceptAll = false}) {
    if (request == null) return;
    Map<String, dynamic> body = {
      "meeting_uid": meetingDetails.meeting_uid,
    };
    if (!acceptAll) {
      body["request_id"] = request.requestId;
      body["is_admit"] = accept;
    } else {
      body["is_admit_all"] = acceptAll;
    }
    apiClient.acceptParticipantInLobby(body).then((response) {
      if (response.success == 1) {
        if (accept) {
          sendMessageToUI("Participant accepted");
        } else {
          sendMessageToUI("Participant rejected");
        }
      } else {
        sendMessageToUI("Something went wrong!");
      }
    });
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
    sendEvent(UpdateView());
  }

  String getPrivateChatIdentity() {
    return _privateChatIdentity;
  }

  var _privateChatUserName = "";

  void setPrivateChatUserName(String name) {
    _privateChatUserName = name;
    notifyListeners();
    sendEvent(UpdateView());
  }

  String getPrivateChatUserName() {
    return _privateChatUserName;
  }

  BuildContext? context;
}
