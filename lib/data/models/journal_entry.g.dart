// GENERATED CODE - DO NOT MODIFY BY HAND
// Hand-written adapter for JournalEntry (skipping build_runner)

part of 'journal_entry.dart';

class JournalEntryAdapter extends TypeAdapter<JournalEntry> {
  @override
  final int typeId = 0;

  @override
  JournalEntry read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return JournalEntry(
      id: fields[0] as String,
      ambienceId: fields[1] as String,
      ambienceTitle: fields[2] as String,
      mood: fields[3] as String,
      text: fields[4] as String,
      createdAt: fields[5] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, JournalEntry obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.ambienceId)
      ..writeByte(2)
      ..write(obj.ambienceTitle)
      ..writeByte(3)
      ..write(obj.mood)
      ..writeByte(4)
      ..write(obj.text)
      ..writeByte(5)
      ..write(obj.createdAt);
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is JournalEntryAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;

  @override
  int get hashCode => typeId.hashCode;
}
