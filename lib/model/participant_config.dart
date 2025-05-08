/// Configuration for the participant's display name.
class ParticipantNameConfig {
  /// The default name to show on the pre-join screen.
  final String? name;

  /// Whether the participant can edit the name.
  ///
  /// This value is only respected if [name] is not empty.
  final bool isEditable;

  const ParticipantNameConfig({
    this.name,
    this.isEditable = true,
  });
}