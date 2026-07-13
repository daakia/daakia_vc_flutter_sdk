import 'package:flutter/material.dart';

import '../resources/colors/color.dart';

/// Self-contained [ThemeData] the SDK applies to its own widget subtree.
///
/// Host apps embed [DaakiaVideoConferenceWidget] inside their own
/// `MaterialApp`/`Theme`, and Flutter's Material widgets (`TextField`,
/// `AlertDialog`, `AppBar`, etc.) fall back to that ambient theme for any
/// property the SDK doesn't hardcode. Since most SDK screens only hardcode
/// the colors they care about, an unrelated host theme (e.g. a global
/// `filled: true` `InputDecorationTheme`) can bleed into unstyled widgets —
/// e.g. the chat message field rendering as a white pill instead of its
/// intended dark container. Using this isolated theme instead of
/// `Theme.of(context)` removes that dependency so every screen looks the
/// same no matter what theme the host app declares.
///
/// The SDK doesn't support host-configurable theming yet — this is a fixed
/// default. When that lands, it becomes the base a theme config can override.
class DaakiaSdkTheme {
  DaakiaSdkTheme._();

  /// For screens that render before the in-meeting UI (loading,
  /// license-expired, pre-join) — these already hardcode a light-card /
  /// dark-text look, so this just isolates them from the host's theme
  /// rather than redesigning them.
  static final ThemeData preMeeting = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(seedColor: themeColor),
  );

  /// For the in-meeting UI (room.dart's inner MaterialApp). Same base as
  /// [preMeeting] — the SDK's dialogs are consistently designed as light
  /// Material cards over the meeting's dark backdrop — with the backdrop
  /// forced black.
  static final ThemeData meeting = preMeeting.copyWith(
    scaffoldBackgroundColor: Colors.black,
  );
}
