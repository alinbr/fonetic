class Line {
  final String? id;
  final String text;
  final String note;
  final int order;
  final String character;

  Line({
    this.id,
    required this.text,
    required this.note,
    required this.order,
    required this.character,
  });

  Line.fromJson(Map<String, dynamic> json)
      : this(
          text: json['text']! as String,
          note: json['note'] ?? ' ',
          order: json['order'] ?? 0,
          character: json['character'] ?? '',
        );
}
