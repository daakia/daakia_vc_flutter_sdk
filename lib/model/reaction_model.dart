class Reaction {
  final String? emoji;
  final String? reactor;
  final String? name;

  Reaction({this.emoji, this.reactor, this.name});

  factory Reaction.fromJson(Map<String, dynamic> json) {
    return Reaction(
      emoji: json['emoji'] as String?,
      reactor: json['reactor'] as String?,
      name: json['name'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'emoji': emoji,
      'reactor': reactor,
      'name': name,
    };
  }
}