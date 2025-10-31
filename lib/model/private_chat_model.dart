import 'package:daakia_vc_flutter_sdk/model/edit_message.dart';
import 'package:daakia_vc_flutter_sdk/model/remote_activity_data.dart';
import 'package:daakia_vc_flutter_sdk/model/reply_message.dart';

class PrivateChatModel {
  final String identity;
  final String name;
  final List<RemoteActivityData> chats;
  int unreadCount;
  bool isSelected;
  RemoteActivityData? pinnedChat;
  ReplyMessage? replyMessage;
  EditMessage? editMessage;

  PrivateChatModel({
    required this.identity,
    required this.name,
    required this.chats,
    this.isSelected = false,
    this.unreadCount = 0,
    this.pinnedChat,
    this.replyMessage,
    this.editMessage,
  });
}
