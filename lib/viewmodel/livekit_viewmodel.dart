import 'dart:convert';

import 'package:daakia_vc_flutter_sdk/model/remote_activity_data.dart';
import 'package:flutter/cupertino.dart';
import 'package:livekit_client/livekit_client.dart';
import 'package:uuid/uuid.dart';

import '../model/send_message_model.dart';

class LivekitViewmodel extends ChangeNotifier {
  final List<RemoteActivityData> _messageList = [];
  late Room room;

  bool isChatOpen = false;
  int _unreadMessageCount = 0;

  int getUnReadCount(){
    return _unreadMessageCount;
  }

  void increaseUnreadCount(){
    print("ChatPage Open?: $isChatOpen");
    if(isChatOpen) return;
    _unreadMessageCount ++;
    notifyListeners();
  }

  void resetUnreadCount(){
    _unreadMessageCount=0;
    notifyListeners();
  }

  LivekitViewmodel(this.room);


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
}
