class RecordedLine {
  final int order;
  final int durationInMiliseconds;
  final String audioLink;

  RecordedLine({
    required this.order,
    required this.audioLink,
    required this.durationInMiliseconds,
  });

  RecordedLine.fromJson(Map<String, dynamic> json)
      : this(
            order: json['order'] as int,
            audioLink: json['audioLink'] ?? ' ',
            durationInMiliseconds: json['durationInMiliseconds'] ?? 1);

  Map<String, Object?> toJson() {
    return {
      'order': order,
      'audioLink': audioLink,
      'durationInMiliseconds': durationInMiliseconds,
    };
  }
}
