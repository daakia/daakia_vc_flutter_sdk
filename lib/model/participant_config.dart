/// Configuration for the participant's display name.
class ParticipantNameConfig {
  /// The default name to show on the pre-join screen.
  final String? name;

  /// Whether the participant can edit the name.
  ///
  /// This value is only respected if [name] is not empty.
  final bool isEditable;

  /// If `name` is provided inside [ParticipantNameConfig] and is non-empty,
  /// then the `isEditable` flag controls whether the user can modify it in the pre-join screen.
  ///
  /// If `name` is not provided or is empty, the name field will always be editable.
  const ParticipantNameConfig({
    this.name,
    this.isEditable = true,
  });
}