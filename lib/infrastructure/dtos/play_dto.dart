import 'package:enum_to_string/enum_to_string.dart';
import 'package:fonetic/infrastructure/dtos/character_dto.dart';

enum PlayStatus { IN_PROGRESS, POST_PRODUCTION, FINISHED }

class PlayDto {
  final String? id;
  final String producerId;
  final String scriptTemplateId;
  final PlayStatus playStatus;
  final List<Character> characters;

  PlayDto({
    this.id,
    required this.producerId,
    required this.scriptTemplateId,
    required this.playStatus,
    required this.characters,
  });

  PlayDto.fromJson(Map<String, Object?> json, String id)
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

  PlayDto copyWith({
    producerId,
    scriptTemplateId,
    playStatus,
    characters,
  }) {
    return PlayDto(
        id: id,
        producerId: producerId ?? this.producerId,
        scriptTemplateId: scriptTemplateId ?? this.scriptTemplateId,
        playStatus: playStatus ?? this.playStatus,
        characters: characters ?? this.characters);
  }
}
