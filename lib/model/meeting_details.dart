import 'package:daakia_vc_flutter_sdk/model/features.dart';
import 'package:daakia_vc_flutter_sdk/model/meeting_details_model.dart';

class MeetingDetails {
  final String meetingUid;
  final Features? features;
  String authorizationToken;
  MeetingDetailsModel? meetingBasicDetails;

  MeetingDetails(
      {required this.meetingUid,
      this.features,
      required this.authorizationToken,
      required this.meetingBasicDetails});
}
