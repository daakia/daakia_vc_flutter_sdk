import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:daakia_vc_flutter_sdk/utils/constants.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mime/mime.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:safe_device/safe_device.dart';

FutureOr<void> Function()? onWindowShouldClose;

class Utils {
  Utils._privateConstructor();

  static final Utils _instance = Utils._privateConstructor();

  factory Utils() {
    return _instance;
  }

  static bool isMobileDevice() {
    if (kIsWeb) {
      return false;
    }
    if (Platform.isAndroid || Platform.isIOS) {
      return true;
    } else {
      return false;
    }
  }

  static void showSnackBar(BuildContext context,
      {required String message, String? actionText, Function? actionCallBack}) {
    if (!context.mounted) return;
    final snackBar = SnackBar(
      content: Text(message),
      action: actionText != null
          ? SnackBarAction(
              label: actionText,
              onPressed: () {
                actionCallBack?.call();
              },
            )
          : null,
    );

    // Find the ScaffoldMessenger in the widget tree
    // and use it to show a SnackBar.
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  static String getTimeZoneId() {
    return DateTime.now().timeZoneName;
  }

  static String formatTimestampToTime(int? timestamp) {
    if (timestamp == null) {
      return "N/A"; // Return "N/A" if the timestamp is null
    }
    DateTime date = DateTime.fromMillisecondsSinceEpoch(timestamp);
    // Format the date to the desired format
    final formatter = DateFormat('hh:mm a'); // 12-hour format
    return formatter.format(date);
  }

  static String getInitials(String? fullName) {
    // Return "U" if the full name is null
    if (fullName == null || fullName.isEmpty) return "U";

    // Split the full name by spaces
    List<String> nameParts = fullName.split(" ");

    // Filter out empty parts, get the first letter of each part, capitalize it, and join without spaces
    return nameParts
        .where((part) => part.isNotEmpty)
        .map((part) => part[0].toUpperCase())
        .join();
  }

  static Color generateUniqueColorFromInitials(String initials) {
    // Convert the initials to a hash code and use modulo to limit the range
    int hash = initials.hashCode.abs();
    double hue =
        (hash % 360).toDouble(); // Map hash to hue angle (0-360 degrees)
    double saturation = 0.7; // Set saturation (0-1)
    double brightness = 0.9; // Set brightness (0-1)

    // Convert HSB (Hue, Saturation, Brightness) to RGB
    return HSVColor.fromAHSV(1.0, hue, saturation, brightness).toColor();
  }

  static int calculateMinutesSince(DateTime? joinedAt) {
    if (joinedAt == null) return 0;
    final currentTime = DateTime.now();
    final difference = currentTime.difference(joinedAt);
    return difference.inMinutes;
  }

  static String getMetadataRole(String? metadata) {
    if (metadata == null) return '';

    try {
      final jsonObject = jsonDecode(metadata);
      return jsonObject['role_name'] ?? '';
    } catch (e) {
      // Handle parsing error, return a default value if needed
      return '';
    }
  }

  static String getParticipantType(String? metadata) {
    String role = getMetadataRole(metadata);

    switch (role) {
      case 'moderator':
        return ' (Host)';
      case 'cohost':
        return ' (Co-Host)';
      default:
        return '';
    }
  }

  static bool isHost(String? metadata) {
    String role = getMetadataRole(metadata);
    return role == 'moderator';
  }

  static bool isCoHost(String? metadata) {
    String role = getMetadataRole(metadata);
    return role == 'cohost';
  }

  static Future<bool> isIosSimulator() async {
    var isRealDevice = await SafeDevice.isRealDevice;
    return isRealDevice;
  }

  static bool isValidEmail(String email) {
    String pattern =
        r'^[a-zA-Z0-9.a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$';
    RegExp regex = RegExp(pattern);
    return regex.hasMatch(email);
  }

  static Future<String> getAppName() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    return packageInfo.appName;
  }

  static bool isLink(String message) {
    final linkRegExp = RegExp(
      r'((https?:\/\/)?([\w-]+\.)+[\w-]+(\/[\w- ./?%&=]*)?)',
      caseSensitive: false,
    );

    // Check if there's any match for the link
    final matches = linkRegExp.allMatches(message);
    if (matches.isEmpty) {
      return false; // No link found
    }

    // Check if the message contains only a link
    final onlyLink =
        matches.length == 1 && matches.first.group(0) == message.trim();
    return onlyLink
        ? true
        : true; // Contains a link (either only or mixed with other text)
  }

  static bool isOnlyLink(String message) {
    final linkRegExp = RegExp(
      r'((https?:\/\/)?([\w-]+\.)+[\w-]+(\/[\w- ./?%&=]*)?)',
      caseSensitive: false,
    );

    // Check if the message is just a link
    final matches = linkRegExp.allMatches(message.trim());
    return matches.length == 1 && matches.first.group(0) == message.trim();
  }

  static String? extractFirstUrl(String message) {
    final urlRegExp = RegExp(
      r'((https?:\/\/)?([a-zA-Z0-9.-]+\.[a-zA-Z]{2,})(\/[^\s]*)?)',
      caseSensitive: false,
      multiLine: true,
    );

    final match = urlRegExp.firstMatch(message);
    return match
        ?.group(0); // Returns the first match or null if no match is found
  }

  static Future<bool> validateFile(File? file, Function(String error) onError) async {
    if (file == null) {
      onError('File is null');
      return false;
    }

    final mimeType = lookupMimeType(file.path);
    final fileSize = await file.length();

    if (mimeType != null) {
      if (mimeType.startsWith('audio/')) {
        if (fileSize <= 16 * 1024 * 1024) {
          return true; // Valid audio file
        } else {
          onError("Audio file exceeds the size limit (16 MB)");
        }
      }
      if (Constant.documentFileTypes()
          .any((type) => mimeType.startsWith(type))) {
        if (fileSize <= 20 * 1024 * 1024) {
          return true; // Valid text file
        } else {
          onError("Text file exceeds the size limit (20 MB)");
        }
      } else if (mimeType.startsWith('image/')) {
        if (fileSize <= 5 * 1024 * 1024) {
          return true; // Valid image file
        } else {
          onError("Image file exceeds the size limit (5 MB)");
        }
      } else if (mimeType.startsWith('video/')) {
        if (fileSize <= 16 * 1024 * 1024) {
          return true; // Valid video file
        } else {
          onError("Video file exceeds the size limit (16 MB)");
        }
      } else {
        onError("Unsupported file type: $mimeType");
      }
    } else {
      onError('Failed to determine MIME type for "${file.path}"');
    }

    return false; // File is invalid
  }

  static String extractFileName(String url) {
    // Extract the file name from the URL
    final fileName = url.split('/').last;

    // Use a regular expression to find the part after "-file-"
    final match = RegExp(r'-file-(.+)$').firstMatch(fileName);

    // If a match is found, return the matched group; otherwise, return the original file name
    return match != null ? match.group(1)! : fileName;
  }
}
