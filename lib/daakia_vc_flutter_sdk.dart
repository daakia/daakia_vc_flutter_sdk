library daakia_vc_flutter_sdk;

import 'package:daakia_vc_flutter_sdk/api/injection.dart';
import 'package:daakia_vc_flutter_sdk/presentation/screens/license_expired.dart';
import 'package:daakia_vc_flutter_sdk/presentation/screens/loading_screen.dart';
import 'package:daakia_vc_flutter_sdk/presentation/screens/prejoin_screen.dart';
import 'package:flutter/widgets.dart';

import 'model/meeting_details_model.dart';

class DaakiaVideoConferenceWidget extends StatefulWidget {
  const DaakiaVideoConferenceWidget(
      {required this.meetingId,
      required this.secretKey,
      this.isHost = false,
      super.key});

  final String meetingId;
  final String secretKey;
  final bool isHost;

  @override
  State<StatefulWidget> createState() {
    return _DaakiaVideoConferenceState();
  }
}

class _DaakiaVideoConferenceState extends State<DaakiaVideoConferenceWidget> {
  var _isLoading = false;
  var _verified = false;
  var _licenseMessage = "";
  MeetingDetailsModel? meetingDetails;

  @override
  void initState() {
    _verifyLicense();
    super.initState();
  }

  void _verifyLicense() {
    setState(() {
      _isLoading = true;
    });
    Map<String, dynamic> body = {
      "secret_key": widget.secretKey,
      "meeting_uid": widget.meetingId
    };
    networkRequestHandler(
        apiCall: () => apiClient.licenceVerify(body),
        onSuccess: (data) {
          _verified = data?.userVerified ?? false;
          if (_verified) {
            _getMeetingDetails();
            return;
          } else {
            _licenseMessage = "License key not verified!";
          }
          setState(() {
            _isLoading = false;
          });
        },
        onError: (message) {
          setState(() {
            _verified = false;
            _isLoading = false;
            _licenseMessage = message;
          });
        });
  }

  void _getMeetingDetails() {
    networkRequestHandler(
      apiCall: () =>
          apiClient.getMeetingDetails(widget.meetingId, widget.secretKey),
      onSuccess: (response) {
        meetingDetails = response;
        setState(() {
          _isLoading = false;
        });
      },
      onError: (message) {
        setState(() {
          _verified = false;
          _isLoading = false;
          _licenseMessage = message;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget screen = const LoadingScreen();
    if (_isLoading) {
      screen = const LoadingScreen();
    } else if (_verified) {
      screen = PreJoinScreen(
        meetingId: widget.meetingId,
        secretKey: widget.secretKey,
        isHost: widget.isHost,
        basicMeetingDetails: meetingDetails,
      );
    } else {
      screen = LicenseExpiredScreen(_licenseMessage);
    }
    return screen;
  }
}
