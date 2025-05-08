import 'package:daakia_vc_flutter_sdk/model/participant_config.dart';

/// Configuration options for initializing the Daakia meeting.
class DaakiaMeetingConfiguration {
  /// [BETA] Metadata to provide additional information about the participant.
  ///
  /// This field can be used to attach dynamic, custom key-value data (e.g., name, email, etc.).
  /// that may be used for advanced features like personalization or analytics.
  ///
  /// If you plan to use the attendance tracking feature, make sure to include a
  /// unique `"identifier"` key in this map.
  ///
  /// This field is experimental and may change in future versions.
  final Map<String, dynamic>? metadata;

  /// Optional configuration for participant name behavior.
  ///
  /// If `name` is provided inside [ParticipantNameConfig] and is non-empty,
  /// then the `isEditable` flag controls whether the user can modify it in the pre-join screen.
  ///
  /// If `name` is not provided or is empty, the name field will always be editable.
  final ParticipantNameConfig? participantNameConfig;

  /// Defines configuration settings for initializing and customizing
  /// a Daakia meeting session.
  ///
  /// Use this class to pass optional metadata and UI behavior settings
  /// when launching a meeting using the Daakia SDK. This allows developers
  /// to customize aspects like participant information (e.g., name),
  /// and enable advanced features like attendance tracking or analytics.
  ///
  /// Example usage:
  /// ```dart
  /// DaakiaMeetingConfiguration(
  ///   metadata: {'identifier': 'user123', 'email': 'user@example.com'},
  ///   participantNameConfig: ParticipantNameConfig(
  ///     name: 'John Doe',
  ///     isEditable: false,
  ///   ),
  /// );
  /// ```
  ///
  /// All fields are optional and can be left null to use default behavior.
  const DaakiaMeetingConfiguration({
    this.metadata,
    this.participantNameConfig
  });
}
