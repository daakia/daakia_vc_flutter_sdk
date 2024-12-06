
![Logo](https://www.f6s.com/content-resource/media/4017238_b1244117504746312035f33e4d2d052109f7b7e5.jpg)


# How to use




## Installation

add ``daakia_vc_flutter_sdk:`` to your ``pubspec.yaml`` dependencies then run ``flutter pub get``

```yaml
  dependencies:
    daakia_vc_flutter_sdk:
```



## Android
We require a set of permissions that need to be declared in your AppManifest.xml. These are required permissions

```xml
<manifest xmlns:android="http://schemas.android.com/apk/res/android" package="com.your.package">
  <uses-feature android:name="android.hardware.camera" />
  <uses-feature android:name="android.hardware.camera.autofocus" />
  <uses-permission android:name="android.permission.CAMERA" />
  <uses-permission android:name="android.permission.RECORD_AUDIO" />
  <uses-permission android:name="android.permission.ACCESS_NETWORK_STATE" />
  <uses-permission android:name="android.permission.CHANGE_NETWORK_STATE" />
  <uses-permission android:name="android.permission.MODIFY_AUDIO_SETTINGS" />
  <uses-permission android:name="android.permission.BLUETOOTH" android:maxSdkVersion="30" />
  <uses-permission android:name="android.permission.BLUETOOTH_CONNECT" />
  <uses-permission android:name="android.permission.BLUETOOTH_ADMIN" android:maxSdkVersion="30" />
  ...
</manifest>
```
## iOs

Camera and microphone usage need to be declared in your `Info.plist` file.

```
<dict>
  ...
  <key>NSCameraUsageDescription</key>
  <string>$(PRODUCT_NAME) uses your camera</string>
  <key>NSMicrophoneUsageDescription</key>
  <string>$(PRODUCT_NAME) uses your microphone</string>
```

Your application can still run the voice call when it is switched to the background if the background mode is enabled. Select the app target in Xcode, click the Capabilities tab, enable __Background Modes__, and check __Audio, AirPlay, and Picture in Picture__.

Your `Info.plist` should have the following entries.

```
<dict>
  ...
  <key>UIBackgroundModes</key>
  <array>
    <string>audio</string>
  </array>
```

For iOS, the minimum supported deployment target is 12.1. You will need to add the following to your Podfile.

```
platform :ios, '12.1'
```

You may need to delete Podfile.lock and re-run pod install after updating deployment target.
## Usage/Examples

```dart
import 'package:daakia_vc_flutter_sdk/daakia_vc_flutter_sdk.dart';

await Navigator.push<void>(
                    context,
                    MaterialPageRoute(
                        builder: (_) => DaakiaVideoConferenceWidget(
                              meetingId: meetingUID,
                              secretKey: licenseKey,
                              isHost: isHost,
                            )),
                  );
```
Use ``DaakiaVideoConferenceWidget`` to start the meeting.



## Parameters

To run the `DaakiaVideoConferenceWidget`, you will need to pass the following parameters:

- **`meetingId`** (`String`):  
  This parameter is required to join a specific meeting. It helps identify the unique meeting to which the user will connect.

- **`secretKey`** (`String`):  
  This is a license key that grants access to the meeting service. It is necessary for secure access.

- **`isHost`** (`bool`, optional):  
  This optional parameter defines the user's role. When set to `true`, the user will join as the host of the meeting; otherwise, they will be a participant.



## Screen Share

### Android

On Android, you will have to use a
[media projection foreground service](https://developer.android.com/develop/background-work/services/fg-service-types#media-projection).

In the app's AndroidManifest.xml file, declare the service with the appropriate types and permissions as following:

```xml
<manifest xmlns:android="http://schemas.android.com/apk/res/android">
  <!-- Required permissions for screen share -->
  <uses-permission android:name="android.permission.FOREGROUND_SERVICE" />
    <uses-permission android:name="android.permission.FOREGROUND_SERVICE_MEDIA_PROJECTION" />
    <uses-permission android:name="android.permission.FOREGROUND_SERVICE_CAMERA"/>
    <uses-permission android:name="android.permission.FOREGROUND_SERVICE_MICROPHONE"/>
    <uses-permission android:name="android.permission.POST_NOTIFICATIONS" />
  <application>
    ...
    <service
        android:name="de.julianassmann.flutter_background.IsolateHolderService"
        android:enabled="true"
        android:exported="false"
        android:foregroundServiceType="mediaProjection|microphone|camera" />
  </application>
</manifest>
```
### iOs
On iOS, a broadcast extension is needed in order to capture screen content from other apps. See For iOS-specific setup, refer to the [setup guide](example/ios/README.md) for instructions.
## Support

For support, email contact@daakia.co.in.

