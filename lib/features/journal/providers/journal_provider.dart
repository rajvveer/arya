import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../data/models/journal_entry.dart';
import '../../../data/repositories/journal_repository.dart';

final journalRepositoryProvider = Provider<JournalRepository>((ref) {
  return JournalRepository();
});

class JournalNotifier extends StateNotifier<AsyncValue<List<JournalEntry>>> {
  final JournalRepository _repo;

  JournalNotifier(this._repo) : super(const AsyncValue.loading()) {
    _load();
  }

  void _load() {
    state = AsyncValue.data(_repo.getAllEntries());
  }

  Future<void> saveEntry(JournalEntry entry) async {
    await _repo.saveEntry(entry);
    _load();
  }

  JournalEntry? getEntry(String id) => _repo.getEntry(id);
}

final journalProvider =
    StateNotifierProvider<JournalNotifier, AsyncValue<List<JournalEntry>>>(
  (ref) {
    final repo = ref.watch(journalRepositoryProvider);
    return JournalNotifier(repo);
  },
);
