class Character {
  final String? userId;
  final String character;

  Character(this.userId, this.character);

  Map<String, Object?> toJson() {
    return {'userId': userId, 'character': character};
  }

  Character.fromJson(Map<String, Object?> json)
      : this(
          json['userId'] as String?,
          json['character'] as String,
        );

  Character copyWith({userId, character}) {
    return Character(userId ?? this.userId, character ?? this.character);
  }
}
