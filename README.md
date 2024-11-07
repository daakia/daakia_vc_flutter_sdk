
![Logo](https://www.f6s.com/content-resource/media/4017238_b1244117504746312035f33e4d2d052109f7b7e5.jpg)


# How to use




### Installation

add ``daakia_vc_flutter_sdk:`` to your ``pubspec.yaml`` dependencies then run ``flutter pub get``

```yaml
  dependencies:
    daakia_vc_flutter_sdk:
```

## Usage/Examples

```flutter
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



## Support

For support, email contact@daakia.co.in.

