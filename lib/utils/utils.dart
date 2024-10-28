import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

FutureOr<void> Function()? onWindowShouldClose;

class Utils {

  Utils._privateConstructor();
  static final Utils _instance = Utils._privateConstructor();
  factory Utils(){
    return _instance;
  }


  // static Future<String> getAppVersion() async {
  //   PackageInfo packageInfo = await PackageInfo.fromPlatform();
  //   String version = packageInfo.version;  // Version name
  //   String buildNumber = packageInfo.buildNumber;  // Build number
  //   return "Version: $version, Build: $buildNumber";
  // }
  //
  // static Future<String?> getDeviceIdentity() async {
  //   final deviceInfo = DeviceInfoPlugin();
  //
  //   try {
  //     if (Platform.isAndroid) {
  //       // Get Android-specific device information
  //       AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
  //       return androidInfo.id; // ANDROID_ID
  //     } else if (Platform.isIOS) {
  //       // Get iOS-specific device information
  //       IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
  //       return iosInfo.identifierForVendor; // Unique device ID on iOS
  //     } else {
  //       return "Unsupported Platform";
  //     }
  //   } catch (e) {
  //     print("Error retrieving device identity: $e");
  //     return null;
  //   }
  // }

  static bool isMobileDevice(){
    if(kIsWeb){
      return false;
    }
    if(Platform.isAndroid || Platform.isIOS){
      return true;
    } else {
      return false;
    }
  }

  static void showSnackBar(BuildContext context, {required String message, String? actionText, Function? actionCallBack}){
    final snackBar = SnackBar(
      content: Text(message),
      action: actionText != null? SnackBarAction(
        label: actionText,
        onPressed: () {
          actionCallBack?.call();
        },
      ) : null,
    );

    // Find the ScaffoldMessenger in the widget tree
    // and use it to show a SnackBar.
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  static String getTimeZoneId() {
    return DateTime.now().timeZoneName;
  }

  static String getToken(){
    return "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzZWNyZXRLZXkiOiI2NjRmMmYzNzYzNTYyNDUwMzAyNTVlMzY1NDQ5Mzc1YiIsIml2S2V5IjoiNGM3NjczMjEyNjNjNzIyNiIsImljZV9zZXJ2ZXJfdHVybiI6InR1cm46dHVybi5kYWFraWEuY28uaW46MzQ3OCIsImljZV9zZXJ2ZXJfc3R1biI6InN0dW46c3R1bi5kYWFraWEuY28uaW46MzQ3OCIsImljZV91c2VybmFtZSI6Imphc3ByZWV0IiwiaWNlX3Bhc3N3b3JkIjoiMTIzNDU2NzgiLCJ1c2VybmFtZSI6IjZjNDU2ZTBkLWE2YjktNDliZi04MmJlLTllZDBjNjhiMjg5ZCIsIm1vYmlsZSI6IjkxOTczNTgyMTM5OCIsImNvdW50cnlfY29kZSI6IjkxIiwic2Vzc2lvbl9pZCI6Ik5NSm81QmNsU01KZUxJc2VFVW5tcFRQaiIsImlhdCI6MTcyODI5NDMwMywiZXhwIjoxNzU5ODUxOTAzfQ.OeKzu-wESnk1mWzmzkxiiWjHGl26Ea3xngc4Zsep1Io";
  }
}
