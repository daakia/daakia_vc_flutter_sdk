enum ChatType {
  public,
  private
}

extension ChatTypeExtension on ChatType {
  /// Convert enum to string
  String get value => name;

  /// Convert string to enum
  static ChatType fromString(String type) {
    switch (type.toLowerCase()) {
      case 'public':
        return ChatType.public;
      case 'private':
        return ChatType.private;
      default:
        throw ArgumentError('Invalid ChatType: $type');
    }
  }
}


