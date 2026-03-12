import 'package:hive/hive.dart';

part 'journal_entry.g.dart';

@HiveType(typeId: 0)
class JournalEntry extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String ambienceId;

  @HiveField(2)
  final String ambienceTitle;

  @HiveField(3)
  final String mood;

  @HiveField(4)
  final String text;

  @HiveField(5)
  final DateTime createdAt;

  JournalEntry({
    required this.id,
    required this.ambienceId,
    required this.ambienceTitle,
    required this.mood,
    required this.text,
    required this.createdAt,
  });

  String get previewText {
    final lines = text.trim().split('\n');
    final firstLine = lines.first.trim();
    if (firstLine.length <= 80) return firstLine;
    return '${firstLine.substring(0, 80)}…';
  }
}
