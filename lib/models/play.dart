import 'package:enum_to_string/enum_to_string.dart';

enum PlayStatus { IN_PROGRESS, POST_PRODUCTION, FINISHED }

class Play {
  final String? id;
  final String producerId;
  final String scriptTemplateId;
  final PlayStatus playStatus;
  final List<Character> characters;

  Play({
    this.id,
    required this.producerId,
    required this.scriptTemplateId,
    required this.playStatus,
    required this.characters,
  });

  Play.fromJson(Map<String, Object?> json, String id)
      : this(
            id: id,
            producerId: json['producerId'] as String,
            scriptTemplateId: json['scriptTemplateId'] as String,
            playStatus: EnumToString.fromString(
                PlayStatus.values, json['playStatus'] as String)!,
            characters: (json['characters'] as List)
                .map((e) => Character.fromJson(e))
                .toList());

  Map<String, Object?> toJson() {
    return {
      'producerId': producerId,
      'scriptTemplateId': scriptTemplateId,
      'playStatus': EnumToString.convertToString(playStatus),
      'characters': characters.map((element) => element.toJson()).toList()
    };
  }

  Play copyWith({
    producerId,
    scriptTemplateId,
    playStatus,
    characters,
  }) {
    return Play(
        id: id,
        producerId: producerId ?? this.producerId,
        scriptTemplateId: scriptTemplateId ?? this.scriptTemplateId,
        playStatus: playStatus ?? this.playStatus,
        characters: characters ?? this.characters);
  }
}

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
