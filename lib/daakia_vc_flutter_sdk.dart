library daakia_vc_flutter_sdk;

import 'package:daakia_vc_flutter_sdk/api/injection.dart';
import 'package:daakia_vc_flutter_sdk/screens/license_expired.dart';
import 'package:daakia_vc_flutter_sdk/screens/loading_screen.dart';
import 'package:daakia_vc_flutter_sdk/screens/prejoin_screen.dart';
import 'package:flutter/widgets.dart';

class DaakiaVideoConferenceWidget  extends StatefulWidget{
  const DaakiaVideoConferenceWidget({required this.meetingId, required this.secretKey, this.isHost = false, super.key});

  final String meetingId;
  final String secretKey;
  final bool isHost;
  @override
  State<StatefulWidget> createState() {
    return _DaakiaVideoConferenceState();
  }

}

class _DaakiaVideoConferenceState extends State<DaakiaVideoConferenceWidget>{
  var _isLoading = false;
  var _verified = false;
  var _licenseMessage = "";
  @override
  void initState() {
    verifyLicense();
    super.initState();
  }

  void verifyLicense(){
    setState(() {
      _isLoading = true;
    });
    Map<String, dynamic> body = {
      "secret_key": widget.secretKey,
      "meeting_uid": widget.meetingId
    };
    apiClient.licenceVerify(body).then((response){
      if(response.success == 1){
        _verified = response.data?.userVerified ?? false;
      } else {
        _verified = false;
        _licenseMessage = "License key not verified";
      }
      setState(() {_isLoading = false;});
    }).onError((handleError, stackStress) {
      setState(() {
        _verified = false;
        _isLoading = false;
        _licenseMessage = "Something went wrong!";
      });
    });
  }
  @override
  Widget build(BuildContext context) {
    Widget screen = LoadingScreen();
    if(_isLoading){
      screen = LoadingScreen();
    } else if(_verified){
      screen = PreJoinScreen(meetingId: widget.meetingId, secretKey: widget.secretKey, isHost: widget.isHost);
    } else{
      screen = LicenseExpiredScreen(_licenseMessage);
    }
    return screen;
  }
}
