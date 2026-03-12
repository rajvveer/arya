// GENERATED CODE - DO NOT MODIFY BY HAND
// Hand-written adapter for SessionStateModel (skipping build_runner)

part of 'session_state_model.dart';

class SessionStateModelAdapter extends TypeAdapter<SessionStateModel> {
  @override
  final int typeId = 1;

  @override
  SessionStateModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SessionStateModel(
      ambienceId: fields[0] as String,
      ambienceTitle: fields[1] as String,
      elapsedSeconds: fields[2] as int,
      isPlaying: fields[3] as bool,
      totalDurationSeconds: fields[4] as int,
    );
  }

  @override
  void write(BinaryWriter writer, SessionStateModel obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.ambienceId)
      ..writeByte(1)
      ..write(obj.ambienceTitle)
      ..writeByte(2)
      ..write(obj.elapsedSeconds)
      ..writeByte(3)
      ..write(obj.isPlaying)
      ..writeByte(4)
      ..write(obj.totalDurationSeconds);
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SessionStateModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;

  @override
  int get hashCode => typeId.hashCode;
}
