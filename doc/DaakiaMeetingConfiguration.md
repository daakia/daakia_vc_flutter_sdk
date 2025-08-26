# DaakiaMeetingConfiguration

The `DaakiaMeetingConfiguration` class allows advanced customization for the Daakia Video Conference SDK.  
It includes optional metadata for participants and participant name behavior.

> **Note:** This is optional. If not provided, default behavior will be used.

---

## Table of Contents
- [Usage](#usage)
- [Metadata](#metadata)
- [Participant Name Configuration](#participant-name-configuration)
- [Examples](#examples)
- [Best Practices](#best-practices)

---

## Usage

Pass an instance of `DaakiaMeetingConfiguration` when launching a meeting:

```dart
import 'package:daakia_vc_flutter_sdk/daakia_vc_flutter_sdk.dart';

await Navigator.push<void>(
  context,
  MaterialPageRoute(
    builder: (_) => DaakiaVideoConferenceWidget(
      meetingId: meetingUID,
      secretKey: licenseKey,
      isHost: isHost,
      configuration: DaakiaMeetingConfiguration(
        metadata: {'identifier': 'user123', 'email': 'user@example.com'},
        participantNameConfig: ParticipantNameConfig(
          name: 'John Doe',
          isEditable: false,
        ),
      ),
    ),
  ),
);
```

---
## Metadata

The `metadata` field allows you to provide additional, dynamic information about the participant. It is optional and marked as **[BETA]**, which means it may change in future versions.

### Features

- Attach custom key-value pairs for participants (e.g., `"name"`, `"email"`, `"role"`, etc.).
- Useful for advanced features like **attendance tracking**, **analytics**, or **personalization**.
- If using the **attendance tracking feature**, ensure to include a unique `"identifier"` key in the metadata.

### Example

```dart
DaakiaMeetingConfiguration(
  metadata: {
    'identifier': 'user123',
    'name': 'John Doe',
    'email': 'john.doe@example.com'
  },
);
```

---
## Participant Name Configuration

The `participantNameConfig` field allows you to control the behavior of the participant name field in the pre-join screen. It is optional.

### Features

- **Set a default name:** Pre-fill the participant name with a value.
- **Control editability:** Decide whether participants can edit their name before joining the meeting.

### Properties

| Property | Type | Description |
|----------|------|-------------|
| `name` | `String` | The default display name for the participant. If not provided or empty, the name field will always be editable. |
| `isEditable` | `bool` | Determines if the participant can modify the name in the pre-join screen. Defaults to `true` if `name` is empty. |

### Example

```dart
DaakiaMeetingConfiguration(
  participantNameConfig: ParticipantNameConfig(
    name: 'John Doe',
    isEditable: false,
  ),
);
```

---
## Examples

### Example 1: Basic Metadata

```dart
DaakiaMeetingConfiguration(
  metadata: {
    'identifier': 'user123',
    'email': 'user@example.com',
  },
);
```
### Example 2: Participant Name Configuration

```dart
DaakiaMeetingConfiguration(
  participantNameConfig: ParticipantNameConfig(
    name: 'John Doe',
    isEditable: false,
  ),
);
```

### Example 3: Combined Metadata and Participant Name

```dart
DaakiaMeetingConfiguration(
  metadata: {
    'identifier': 'user123',
    'email': 'user@example.com',
  },
  participantNameConfig: ParticipantNameConfig(
    name: 'John Doe',
    isEditable: true,
  ),
);
```

> ✅ Tip: Including a unique `identifier` key in `metadata` is recommended if you plan to use attendance tracking features.

---
## Best Practices

- **Unique Identifier:** Always include a unique `"identifier"` key in `metadata` for tracking participants reliably.
- **Minimal Metadata:** Only include the necessary keys in `metadata` to reduce payload size and improve performance.
- **Editable Names:** Set `isEditable` in `ParticipantNameConfig` thoughtfully. If participants shouldn’t change their names, set it to `false`.
- **Consistency:** Use consistent keys and naming conventions in `metadata` across all participants for easier data handling.
- **Security:** Avoid storing sensitive information in `metadata` as it may be accessible on the client side.
- **Future-Proofing:** Since this is a BETA feature, keep your implementation flexible to accommodate future updates or new fields.