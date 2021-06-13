class Character {
  final String? userId;
  final String character;

  Character({this.userId, required this.character});

  Map<String, Object?> toJson() {
    return {'userId': userId, 'character': character};
  }

  Character.fromJson(Map<String, Object?> json)
      : this(
          userId: json['userId'] as String?,
          character: json['character'] as String,
        );

  Character copyWith({userId, character}) {
    return Character(
      userId: userId ?? this.userId,
      character: character ?? this.character,
    );
  }
}
