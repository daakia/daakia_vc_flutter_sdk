import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:device_info_plus/device_info_plus.dart';

class DeviceNetworkInfo {
  static final DeviceInfoPlugin _deviceInfo = DeviceInfoPlugin();

  /// Get userAgent equivalent: device + OS version
  static Future<String> getDeviceDetails() async {
    if (Platform.isAndroid) {
      final info = await _deviceInfo.androidInfo;
      return 'Android ${info.version.release} (SDK ${info.version.sdkInt}), ${info.manufacturer} ${info.model}';
    } else if (Platform.isIOS) {
      final info = await _deviceInfo.iosInfo;
      return 'iOS ${info.systemVersion}, ${info.name} (${info.model})';
    }
    return '${Platform.operatingSystem} ${Platform.operatingSystemVersion}';
  }

  /// Get network type: wifi, mobile, ethernet, none
  static Future<String> getNetworkType() async {
    final results = await Connectivity().checkConnectivity();
    if (results.contains(ConnectivityResult.mobile)) {
      return 'mobile'; // optionally refine 3G/4G/5G
    } else if (results.contains(ConnectivityResult.wifi)) {
      return 'wifi';
    } else if (results.contains(ConnectivityResult.ethernet)) {
      return 'ethernet';
    } else if (results.contains(ConnectivityResult.none)) {
      return 'no-internet';
    } else {
      return 'unknown';
    }
  }

}
