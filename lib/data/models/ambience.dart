class Ambience {
  final String id;
  final String title;
  final String tag;
  final int durationSeconds;
  final String description;
  final String imageAsset;
  final List<String> sensoryRecipes;

  const Ambience({
    required this.id,
    required this.title,
    required this.tag,
    required this.durationSeconds,
    required this.description,
    required this.imageAsset,
    required this.sensoryRecipes,
  });

  factory Ambience.fromJson(Map<String, dynamic> json) {
    return Ambience(
      id: json['id'] as String,
      title: json['title'] as String,
      tag: json['tag'] as String,
      durationSeconds: json['durationSeconds'] as int,
      description: json['description'] as String,
      imageAsset: json['imageAsset'] as String,
      sensoryRecipes: List<String>.from(json['sensoryRecipes'] as List),
    );
  }

  String get formattedDuration {
    final minutes = durationSeconds ~/ 60;
    final seconds = durationSeconds % 60;
    if (seconds == 0) return '$minutes min';
    return '$minutes:${seconds.toString().padLeft(2, '0')} min';
  }
}
