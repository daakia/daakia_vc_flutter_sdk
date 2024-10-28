import 'dart:io';

class Constant {
  static final String PLATFORM = getPlatform();
  static const String APP_ID = "DM-1001";

  static const String LIVEKIT_TOKEN = "eyJhbGciOiJIUzI1NiJ9.eyJtZXRhZGF0YSI6IntcInJvbGVfbmFtZVwiOlwibW9kZXJhdG9yXCIsXCJtZWV0aW5nX2F0dGVuZGFuY2VfaWRcIjoxMzc3fSIsIm5hbWUiOiJBc2hpZiIsInZpZGVvIjp7InJvb21Kb2luIjp0cnVlLCJyb29tIjoiNzQxNDQzMzY3NjMzIn0sImlzcyI6ImI4Y2NiNTRmLTA0MDctNDA3Yy1hYWRhLTNlZTk0ZDVmZDYzNyIsImV4cCI6MTcyOTg1ODIwNSwibmJmIjowLCJzdWIiOiI2YzQ1NmUwZC1hNmI5LTQ5YmYtODJiZS05ZWQwYzY4YjI4OWQifQ.0sQOyizGyrDAZ46V6ubQ4A-6KWq1hbuZ2XT_anxZ5t0";
  static const String LIVEKIT_URL = "https://ap1sfu-dev.vc.daakia.co.in";

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
