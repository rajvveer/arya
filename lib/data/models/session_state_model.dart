import 'package:hive/hive.dart';

part 'session_state_model.g.dart';

@HiveType(typeId: 1)
class SessionStateModel extends HiveObject {
  @HiveField(0)
  String ambienceId;

  @HiveField(1)
  String ambienceTitle;

  @HiveField(2)
  int elapsedSeconds;

  @HiveField(3)
  bool isPlaying;

  @HiveField(4)
  int totalDurationSeconds;

  SessionStateModel({
    required this.ambienceId,
    required this.ambienceTitle,
    required this.elapsedSeconds,
    required this.isPlaying,
    required this.totalDurationSeconds,
  });
}
