enum PlayStatus { IN_PROGRESS, POST_PRODUCTION, FINISHED }

class Play {
  final String producerId;
  final String scriptTemplateId;
  final PlayStatus playStatus;
  final List<Character> characters;

  Play({
    required this.producerId,
    required this.scriptTemplateId,
    required this.playStatus,
    required this.characters,
  });

  Play.fromJson(Map<String, Object?> json)
      : this(
            producerId: '1',
            scriptTemplateId: 'a',
            playStatus: PlayStatus.IN_PROGRESS,
            characters: List<Character>.empty());

  Map<String, Object?> toJson() {
    return {
      'producerId': producerId,
      'scriptTemplateId': scriptTemplateId,
      'playStatus': playStatus.toString(),
      'characters': characters.map((element) => element.toJson()).toList()
    };
  }
}

class Character {
  final String? userId;
  final String character;

  Character(this.userId, this.character);

  Map<String, Object?> toJson() {
    return {'userId': userId, 'character': character};
  }
}
