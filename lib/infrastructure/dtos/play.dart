import 'package:enum_to_string/enum_to_string.dart';
import 'package:fonetic/infrastructure/dtos/character.dart';

enum PlayStatus { IN_PROGRESS, POST_PRODUCTION, FINISHED }

class Play {
  final String? id;
  final String producerId;
  final String scriptId;
  final PlayStatus playStatus;
  final List<Character> characters;

  final String cover;
  final String description;
  final int duration;
  final String name;
  final int roles;

  Play({
    this.id,
    required this.producerId,
    required this.scriptId,
    required this.playStatus,
    required this.characters,
    required this.cover,
    required this.description,
    required this.duration,
    required this.name,
    required this.roles,
  });

  Play.fromJson(Map<String, Object?> json, String id)
      : this(
          id: id,
          producerId: json['producerId'] as String,
          scriptId: json['scriptTemplate'] as String,
          playStatus: EnumToString.fromString(
              PlayStatus.values, json['playStatus'] as String)!,
          characters: (json['characters'] as List)
              .map((e) => Character.fromJson(e))
              .toList(),
          cover: json['cover'] as String,
          description: json['description'] as String,
          duration: json['duration'] as int,
          name: json['name'] as String,
          roles: json['roles'] as int,
        );

  Map<String, Object?> toJson() {
    return {
      'producerId': producerId,
      'scriptTemplate': scriptId,
      'playStatus': EnumToString.convertToString(playStatus),
      'characters': characters.map((element) => element.toJson()).toList(),
      'cover': cover,
      'description': description,
      'duration': duration,
      'name': name,
      'roles': roles
    };
  }

  Play copyWith({
    producerId,
    scriptId,
    playStatus,
    characters,
    cover,
    description,
    duration,
    name,
    roles,
  }) {
    return Play(
      id: id,
      producerId: producerId ?? this.producerId,
      scriptId: scriptId ?? this.scriptId,
      playStatus: playStatus ?? this.playStatus,
      characters: characters ?? this.characters,
      cover: cover ?? this.cover,
      description: description ?? this.description,
      duration: duration ?? this.duration,
      name: name ?? this.name,
      roles: roles ?? this.roles,
    );
  }
}
