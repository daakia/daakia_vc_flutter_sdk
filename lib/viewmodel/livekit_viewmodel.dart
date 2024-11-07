import 'dart:convert';

import 'package:daakia_vc_flutter_sdk/api/injection.dart';
import 'package:daakia_vc_flutter_sdk/model/remote_activity_data.dart';
import 'package:daakia_vc_flutter_sdk/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:livekit_client/livekit_client.dart';
import 'package:uuid/uuid.dart';
import 'package:collection/collection.dart';

import '../livekit/widgets/participant_info.dart';
import '../model/action_model.dart';
import '../model/meeting_details.dart';
import '../model/send_message_model.dart';

class LivekitViewmodel extends ChangeNotifier {
  final List<RemoteActivityData> _messageList = [];
  final List<RemoteActivityData> _lobbyRequestList = [];
  late Room room;
  late MeetingDetails meetingDetails;

  String _uiMessage = "";

  List<ParticipantTrack> _participantTracks = [];

  bool isChatOpen = false;
  int _unreadMessageCount = 0;

  bool _isCoHost = false;

  bool _isRecording = false;

  void setCoHost(bool isCoHost){
    _isCoHost = isCoHost;
    notifyListeners();
  }

  bool getCoHost() => _isCoHost;

  int getUnReadCount() {
    return _unreadMessageCount;
  }

  void increaseUnreadCount() {
    print("ChatPage Open?: $isChatOpen");
    if (isChatOpen) return;
    _unreadMessageCount++;
    notifyListeners();
  }

  void resetUnreadCount() {
    _unreadMessageCount = 0;
    notifyListeners();
  }

  LivekitViewmodel(this.room, this.meetingDetails);

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

  Future<void> sendData(String userMessage) async {
    // Logging the message
    print("Message: ${jsonEncode(userMessage)}");

    // Create a message
    final message = SendMessageModel(
      id: const Uuid().v4(), // Generate a unique ID
      message: userMessage,
      timestamp: DateTime.now().millisecondsSinceEpoch, // Current timestamp
    );

    // Log the serialized message
    print("Message: ${jsonEncode(message)}");

    // Publish the data to the LiveKit room
    await room.localParticipant?.publishData(
      utf8.encode(jsonEncode(message)), // Convert to bytes,
      reliable: true,
      topic: "lk-chat-topic",
    );

    // Update the message list
    addMessage(
      RemoteActivityData(
        identity: null,
        id: message.id,
        message: message.message,
        timestamp: message.timestamp,
        action: "",
        // Assuming no action is provided
        isSender: true, // isSender
      ),
    );
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
        print('Error sending private action: $e');
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
    } catch (e) {
      print('Error sending action: $e');
    }
  }

  void addParticipant(List<ParticipantTrack> participants) {
    // Clear the existing list
    _participantTracks.clear();

    // Try to find the local participant based on identity
    ParticipantTrack? localParticipant = participants.firstWhereOrNull(
          (participant) => participant.participant.identity == room.localParticipant?.identity,
    );

    // Add the local participant first if it exists
    if (localParticipant != null) {
      _participantTracks.add(localParticipant);
    }

    // Add remaining participants, excluding the local participant if it exists
    _participantTracks.addAll(
      participants.where((participant) => participant.participant.identity != room.localParticipant?.identity),
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

  //===========================Livekit Controls====================

  bool isAudioPermissionEnable = true;
  bool isVideoPermissionEnable = true;
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
    apiClient.removeParticipant(meetingDetails.authorization_token, body).then((response){
      if(response.success == 1){
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
    apiClient.makeCoHost(meetingDetails.authorization_token, body).then((response){
      if(response.success == 1){
        sendPrivateAction(ActionModel(action: "makeCoHost", token: meetingDetails.authorization_token), identity);
      } else {
        sendMessageToUI(response.message ?? "Something went wrong!");
      }
    });
  }

  void setRecording(bool isRecording){
    _isRecording = isRecording;
    notifyListeners();
  }

  bool get isRecording => _isRecording;

  void startRecording() {
    Map<String, dynamic> body = {
      "meeting_uid": meetingDetails.meeting_uid,
    };
    apiClient.startRecording(meetingDetails.authorization_token, body).then((response){
      if(response.success == 1){
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
    apiClient.stopRecording(meetingDetails.authorization_token, body).then((response){
      if(response.success == 1){
        setRecording(false);
        sendMessageToUI("Recording Starting");
      } else {
        sendMessageToUI(response.message ?? "Something went wrong!");
      }
    });
  }

  void sendMessageToUI(String message){
    if(_uiMessage.isNotEmpty) {
      _uiMessage = message;
      notifyListeners();
      _uiMessage = "";
    }
    _uiMessage = "";
  }
  String get uiMessage => _uiMessage;

  bool isHost() {
    return Utils.isHost(room.localParticipant?.metadata);
  }

  bool isCoHost() {
    return Utils.isCoHost(room.localParticipant?.metadata);
  }
}
