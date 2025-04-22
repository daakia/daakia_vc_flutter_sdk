import 'package:flutter/foundation.dart';

// 🔔 IMPORTANT: Keep _validActions Updated! 🔔
//
// Every action constant defined in this class MUST be added to _validActions.
// If you forget, the app may not recognize the action, causing bugs.
//
// Example:
// ❌ Missing action:
//    static const String newAction = "new_action"; // Added here but NOT in _validActions
//
// ✅ Fix:
//    Add `newAction` to _validActions:
//    static final Set<String> _validActions = {
//      ...existingActions,
//      newAction, // ✅ Added correctly
//    };
//
// Keep it updated to avoid issues! 🚀

class MeetingActions {
  static const String raiseHand = "raise_hand";
  static const String stopRaiseHand = "stop_raise_hand";
  static const String stopRaiseHandAll = "stop_raise_hand_all";
  static const String sendPrivateMessage = "send_private_message";
  static const String sendPublicMessage = "send_public_message";
  static const String lobby = "lobby";

  static const String heart = "heart";
  static const String blush = "blush";
  static const String clap = "clap";
  static const String smile = "smile";
  static const String thumbsUp = "thumbsUp";

  static const String muteCamera = "mute_camera";
  static const String muteMic = "mute_mic";
  static const String askToUnmuteMic = "ask_to_unmute_mic";
  static const String askToUnmuteCamera = "ask_to_unmute_camera";

  static const String makeCoHost = "makeCoHost";
  static const String removeCoHost = "removeCoHost";
  static const String forceMuteAll = "force_mute_all";
  static const String forceVideoOffAll = "force_video_off_all";

  static const String showLiveCaption = "show-live-caption";
  static const String liveCaption = "live-caption";
  static const String requestLiveCaptionDrawerState = "request-livecaption-drawer-state";

  static const String extendMeetingEndTime = "extend-meeting-end-time";

  static const String whiteboardState = "whiteboard-state";

  // ✅ Method to check if an action is valid
  static bool isValidAction(String? action) {
    if (action == null) return false; // Ensures action is not null

    bool isValid = _validActions.contains(action);
    if (!isValid) {
      debugPrint("🚨 Invalid action detected: $action");
    }
    return isValid;
  }


  // Private set to prevent modification from outside
  static final Set<String> _validActions = {
    raiseHand,
    stopRaiseHand,
    stopRaiseHandAll,
    sendPrivateMessage,
    sendPublicMessage,
    lobby,
    heart,
    blush,
    clap,
    smile,
    thumbsUp,
    muteCamera,
    muteMic,
    askToUnmuteMic,
    askToUnmuteCamera,
    makeCoHost,
    removeCoHost,
    forceMuteAll,
    forceVideoOffAll,
    showLiveCaption,
    liveCaption,
    requestLiveCaptionDrawerState,
    extendMeetingEndTime,
    whiteboardState
  };
}
