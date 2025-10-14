# CHANGELOG

## v4.2.1 – (2025-10)

### 🚀 New Features
- **Pin to Screen:** Added the ability to pin participants’ video to the main screen for focused view.
- **Restrict Multiple Screen Shares:** Prevents multiple users from sharing their screen simultaneously.
- **Guest Name Storage:** Stores guest user names for better participant identification in meetings.
- **Background Support (Android):** Added a **foreground service** to improve meeting stability and ensure continued operation when the app is in the background.
- **Picture-in-Picture (PiP):** Added PiP mode support for Android to allow multitasking during meetings.
- **Meeting Alerts & Actions:** Added in-meeting alerts and real-time action handling for better event visibility.
- **Recording Flow Update:** Improved recording start/stop logic with `dispatchId` integration, failsafe handling, and UI enhancements.

### 🧩 Improvements
- **UI/UX Enhancements:** General interface refinements and layout improvements.
- Enhanced recording reliability and button state control.
- Improved meeting flow stability and background performance.

---

## v4.2.0 – (2025-09)

### 📱 Android Support
- Added **16KB screen size support** for better compatibility on larger devices.

### 📦 Dependency Updates
- Upgraded to the **latest library versions** for improved stability, security, and long-term support.

### 🛠 Bug Fixes & Improvements
- Various bug fixes and performance enhancements.

---

## v4.1.0 – (2025-09)

### 📊 Analytics & Monitoring
- Implemented **Datadog logging** for improved observability and performance tracking.

---

## v4.0.0 - (2025-08)

### 🚀 New Features
- **Metadata Config:** Introduced configurable metadata support for meetings.
- **Transcript Download:** Participants can now download meeting transcripts.
- **Connectivity Status:** Added in-meeting connectivity banners and participant connectivity indicators.
- **Participant Attendance:** Added tracking of participant attendance.
- **Chat Restrictions:** Host can restrict chat to “Everyone”, “Host & Co-host only”, or “Disabled”.
- **Consent Flow:** Introduced recording/streaming consent popups for participants.
- **SDK Config:** Added centralized configuration for SDK features.
- **Co-Host Management:** Improved APIs and controls for assigning/removing co-hosts.
- **Role-Based Features:** Feature gating based on user role (host, co-host, participant).

### 🛠 Bug Fixes & Improvements
- Fixed memory leaks and optimized participant UI updates.
- Improved transcript accuracy and fixed missing metadata issues.
- Fixed iOS navigation and permission handling.
- Improved state management for recording and live streaming.
- Various stability, crash, and UI fixes across Android & iOS.
- Refactored participant structure for better scalability.
- General performance optimizations and dependency upgrades.

---

## v3.1.2 (2025-04)

### 🚀 New Features
- **Whiteboard (Preview):** Introduced collaborative whiteboard functionality for real-time visual collaboration during meetings.

### 🛠 Bug Fixes & Improvements
- Various bug fixes and performance enhancements.
- Minor UI adjustments for a smoother experience.

## v3.0.1 (2025-04)

### 🚀 New Features
- **Live Transcription:** Automatically transcribe meetings in real time.
- **Translation:** Support for multilingual translations during meetings.
- **End Meeting:** Hosts can now end meetings for all participants.
- **Scheduled Meeting End:** Meetings will now automatically end at the scheduled time based on the subscription plan.
- **Co-Host Modification:** Enhanced co-host management capabilities.
- **Participant Name Change:** Participants can update their display names during a meeting.
- **Auto-Recording:** Meetings now support automatic recording upon start.
- **Meeting Extension:** Host can extend meetings based on their subscription plan.

### 🛠 Bug Fixes & Improvements
- Stability enhancements and performance optimizations.
- General UI and user experience improvements.
- Resolved caching problems affecting co-host functionality.
- Upgraded dependencies for better performance and compatibility.


## 2.1.3 (2025-01) _(Internal Release)_

**Enhancements:**

* **Upload attachments:** Users can now share files within both public and private chat rooms.
* **Web-View:** Added support for displaying web content directly within the chat interface for chat links.
* **Improved UI:** Enhanced the user interface for different media types (images, videos, etc.) for a better visual experience.

## 2.0.1 (2024-12) _(Internal Release)_

- **Bug Fixes**:
  - Null-Safety for participant.
  - Lobby mode bug fixes.
  - Navigation bug fixes.

## 2.0.0 (2024-12) _(Internal Release)_

- **New Features**:
  - Added raise hand feature.
  - Webinar mode & Host controls added.
  - Private & Public chat added.
  - Reaction added.
  - Password Protected event added.
  - Lobby Mode added.
  - Screen Share Added for Android & iOs.
  - PIP Mode added in Android (iOs don't support right now)
- **Bug Fixes**:
  - Connection bug fixes.
  - Permission issue fixed in iOs.

## 1.0.0 (2024-11) _(Internal Release)_

- **Initial Release**:
  - Implemented Web-RTC integration for real-time video and audio calls.
  - Added core functionality for video conferencing.
  - Introduced participant management with local and remote participants.
  - Added cloud recording.