class RecordedLine {
  final int order;
  final String audioLink;

  RecordedLine({required this.order, required this.audioLink});

  RecordedLine.fromJson(Map<String, dynamic> json)
      : this(
          order: json['order'] as int,
          audioLink: json['audioLink'] ?? ' ',
        );

  Map<String, Object?> toJson() {
    return {
      'order': order,
      'audioLink': audioLink,
    };
  }
}
