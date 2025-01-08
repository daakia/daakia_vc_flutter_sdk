import 'dart:io';

class Constant {
  static const bool RELEASE = false;

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
