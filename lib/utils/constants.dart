import 'dart:io';

class Constant {
  static final String PLATFORM = getPlatform();

  static String getPlatform() {
    if (Platform.isAndroid) {
      return "android";
    } else if (Platform.isIOS) {
      return "iOS";
    } else {
      return "unknown";
    }
  }
}
