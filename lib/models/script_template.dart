import 'package:cloud_firestore/cloud_firestore.dart';

class ScriptTemplate {
  final String? id;
  final String name;
  final String description;
  final int roles;
  final int duration;
  final String cover;

  ScriptTemplate(
      {required this.roles,
      required this.duration,
      this.id,
      required this.name,
      required this.description,
      required this.cover});

  Map<String, Object?> toJson() {
    return {'name': name};
  }

  ScriptTemplate.fromJson(Map<String, dynamic> json)
      : this(
          name: json['name']! as String,
          description: json['description'] ?? ' ',
          roles: json['roles'] ?? 0,
          duration: json['duration'] ?? 0,
          cover: json['cover'] ?? '',
        );
}
