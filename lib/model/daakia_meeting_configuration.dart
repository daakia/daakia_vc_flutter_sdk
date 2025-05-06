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

  // Future config options can go here:

  const DaakiaMeetingConfiguration({
    this.metadata,
  });
}
