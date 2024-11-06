import 'package:daakia_vc_flutter_sdk/model/features.dart';

class MeetingDetails{
  final String meeting_uid;
  final Features? features;
  String authorization_token;
  MeetingDetails({required this.meeting_uid, this.features, required this.authorization_token});
}