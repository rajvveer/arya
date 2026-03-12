import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../data/models/ambience.dart';
import '../../../data/repositories/ambience_repository.dart';

final ambienceRepositoryProvider = Provider<AmbienceRepository>((ref) {
  return AmbienceRepository();
});

final ambiencesProvider = FutureProvider<List<Ambience>>((ref) async {
  final repo = ref.watch(ambienceRepositoryProvider);
  return repo.loadAmbiences();
});

final searchQueryProvider = StateProvider<String>((ref) => '');

final selectedTagProvider = StateProvider<String?>((ref) => null);

final filteredAmbiencesProvider = Provider<AsyncValue<List<Ambience>>>((ref) {
  final ambiencesAsync = ref.watch(ambiencesProvider);
  final query = ref.watch(searchQueryProvider).toLowerCase().trim();
  final selectedTag = ref.watch(selectedTagProvider);

  return ambiencesAsync.whenData((ambiences) {
    return ambiences.where((a) {
      final matchesSearch = query.isEmpty ||
          a.title.toLowerCase().contains(query) ||
          a.tag.toLowerCase().contains(query) ||
          a.description.toLowerCase().contains(query);
      final matchesTag = selectedTag == null || a.tag == selectedTag;
      return matchesSearch && matchesTag;
    }).toList();
  });
});
