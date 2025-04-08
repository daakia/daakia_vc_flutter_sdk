import 'package:daakia_vc_flutter_sdk/utils/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StorageHelper {
  Future<void> saveData(String key, String value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(key, value);
  }

  Future<String?> getData(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(key);
  }

  Future<void> clearAllData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

  Future<void> setMeetingUid(String value) async => await saveData(Constant.MEETING_UID, value);
  Future<String?> getMeetingUid() async => await getData(Constant.MEETING_UID);


  Future<void> setSessionUid(String value) async => await saveData(Constant.SESSION_UID, value);
  Future<String?> getSessionUid() async => await getData(Constant.SESSION_UID);


  Future<void> setAttendanceId(String value) async => await saveData(Constant.ATTENDANCE_ID, value);
  Future<String?> getAttendanceId() async => await getData(Constant.ATTENDANCE_ID);
}
