import 'package:daakia_vc_flutter_sdk/model/features.dart';
import 'package:daakia_vc_flutter_sdk/model/meeting_details_model.dart';

class MeetingDetails {
  final String meetingUid;
  final Features? features;
  String authorizationToken;
  String livekitToken;
  MeetingDetailsModel? meetingBasicDetails;
  final String? participantEmail;

  MeetingDetails(
      {required this.meetingUid,
      this.features,
      required this.authorizationToken,
        required this.livekitToken,
      required this.meetingBasicDetails,
      this.participantEmail});
}
