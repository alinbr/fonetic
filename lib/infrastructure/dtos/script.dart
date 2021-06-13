class Script {
  final String? id;
  final String name;
  final String description;
  final int roles;
  final int duration;
  final String cover;
  final List<String> characters;

  Script({
    this.id,
    required this.roles,
    required this.duration,
    required this.name,
    required this.description,
    required this.cover,
    required this.characters,
  });

  Script.fromJson(String id, Map<String, dynamic> json)
      : this(
          id: id,
          name: json['name']! as String,
          description: json['description'] ?? ' ',
          roles: json['roles'] ?? 0,
          duration: json['duration'] ?? 0,
          cover: json['cover'] ?? '',
          characters: json['characters'].cast<String>(),
        );
}
