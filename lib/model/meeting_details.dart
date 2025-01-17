import 'package:daakia_vc_flutter_sdk/model/features.dart';
import 'package:daakia_vc_flutter_sdk/model/meeting_details_model.dart';

class MeetingDetails {
  final String meeting_uid;
  final Features? features;
  String authorization_token;
  MeetingDetailsModel? meetingBasicDetails;

  MeetingDetails(
      {required this.meeting_uid,
      this.features,
      required this.authorization_token,
      required this.meetingBasicDetails});
}
