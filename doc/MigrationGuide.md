# Migration Guide

## Moving `secretKey` to `DaakiaSdk.initialize` (since v4.5.2)

Starting in **v4.5.2**, `DaakiaVideoConferenceWidget.secretKey` is optional and **deprecated**. The
recommended flow is to set the secret key once at app startup via `DaakiaSdk.initialize`, instead of
passing it to every `DaakiaVideoConferenceWidget` instance.

> **Note:** The old flow still works. `secretKey` will continue to be honored as a fallback, but it will
> be removed in a future major version — migrate when convenient.

### Before

```dart
DaakiaVideoConferenceWidget(
  meetingId: meetingUID,
  secretKey: licenseKey,
  isHost: isHost,
)
```

### After

```dart
// main.dart, once at app startup, before runApp()
DaakiaSdk.initialize(
  secret: '<YOUR_SECRET_KEY>',
  baseUrl: '<BASE_URL>',         // optional, defaults to production
  whiteboardDomain: '<WB_URL>',  // optional
);

// meeting screen — no need to pass secretKey anymore
DaakiaVideoConferenceWidget(
  meetingId: meetingUID,
  isHost: isHost,
)
```

### Why migrate

- Avoids repeating the secret key on every widget instantiation.
- If neither `secretKey` nor `DaakiaSdk.initialize(secret: ...)` is set, the widget now shows a clear
  license error instead of failing silently.

### Steps

1. Call `DaakiaSdk.initialize(secret: '<YOUR_SECRET_KEY>')` once in `main()`, before `runApp()`.
2. Remove the `secretKey` argument from every `DaakiaVideoConferenceWidget(...)` call site.
3. If you use `baseUrl` or `whiteboardDomain`, pass them to the same `DaakiaSdk.initialize` call instead of
   configuring them separately.

No other parameters or behavior change as part of this migration.
