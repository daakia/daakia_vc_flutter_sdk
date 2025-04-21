import 'dart:io';

class Constant {
  static final String platform = getPlatform();

  static const String baseUrl = "https://api.daakia.co.in/v2.0/";
  static const String whiteboardDomain = "https://www.daakia.co.in/";

  static const String meetingUid = "MEETING_UID";
  static const String sessionUid = "SESSION_UID";
  static const String attendanceId = "ATTENDANCE_ID";
  static const String hostToken = "HOST_TOKEN";

  static const int meetingExtendTime = 10;
  static const int meetingEndSoonTime = 10;

  static const int maxMessageSize = 16384; // 16 KB limit


  static const int successResCheckValue = 1;

  static String getPlatform() {
    if (Platform.isAndroid) {
      return "android";
    } else if (Platform.isIOS) {
      return "iOS";
    } else {
      return "unknown";
    }
  }

  static List<String>? allowedExtensions(){
    //TODO:: Need to add AMR Audio file in future
    return [
      // Allowed extensions for each media type
      'mp3', 'aac', 'mpeg', 'ogg', // Audio
      'txt', 'pdf', 'ppt', 'doc', 'xls', 'docx', 'pptx', 'xlsx', // Documents
      'jpg', 'jpeg', 'png', 'webp', // Images
      'mp4', '3gp', // Videos
    ];
  }

  static List<String> documentFileTypes() {
    return [
      'application/vnd.openxmlformats-officedocument.wordprocessingml.document', // Word
      'application/vnd.openxmlformats-officedocument.presentationml.presentation', // PowerPoint
      'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet', // Excel
      'application/vnd.ms-excel', // Older Excel format
      'application/msword', // Older Word format
      'application/vnd.ms-powerpoint', // Older PowerPoint format
      'application/pdf', // PDF
      'text/' // Text files
    ];
  }
}
