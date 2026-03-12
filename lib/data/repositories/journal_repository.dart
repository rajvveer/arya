import 'package:hive_flutter/hive_flutter.dart';
import '../models/journal_entry.dart';

class JournalRepository {
  static const _boxName = 'journal_entries';

  Box<JournalEntry> get _box => Hive.box<JournalEntry>(_boxName);

  static Future<void> openBox() async {
    await Hive.openBox<JournalEntry>(_boxName);
  }

  Future<void> saveEntry(JournalEntry entry) async {
    await _box.put(entry.id, entry);
  }

  List<JournalEntry> getAllEntries() {
    final entries = _box.values.toList();
    entries.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return entries;
  }

  JournalEntry? getEntry(String id) => _box.get(id);
}
