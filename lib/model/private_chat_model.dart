import 'package:daakia_vc_flutter_sdk/model/remote_activity_data.dart';

class PrivateChatModel {
  final String identity;
  final String name;
  final List<RemoteActivityData> chats;
  int unreadCount;
  bool isSelected;

  PrivateChatModel({
    required this.identity,
    required this.name,
    required this.chats,
    this.isSelected = false,
    this.unreadCount = 0,
  });
}
