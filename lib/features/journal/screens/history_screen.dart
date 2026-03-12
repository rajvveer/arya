import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../providers/journal_provider.dart';
import '../../../shared/widgets/empty_state.dart';

class HistoryScreen extends ConsumerWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final journalAsync = ref.watch(journalProvider);
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Reflections'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: journalAsync.when(
        data: (entries) {
          if (entries.isEmpty) {
            return const EmptyState(
              message: 'No reflections yet.\nStart a session to begin.',
              icon: Icons.auto_stories_outlined,
            );
          }
          return ListView.builder(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
            itemCount: entries.length,
            itemBuilder: (context, index) {
              final entry = entries[index];
              final formattedDate = DateFormat('MMM d, yyyy · h:mm a')
                  .format(entry.createdAt.toLocal());
              return GestureDetector(
                onTap: () => context.push('/history/${entry.id}'),
                child: Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: scheme.surfaceContainerHighest.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                        color: scheme.outlineVariant.withOpacity(0.3)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              entry.ambienceTitle,
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 15,
                                color: scheme.onSurface,
                              ),
                            ),
                          ),
                          _MoodBadge(mood: entry.mood),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        entry.previewText,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 14,
                          color: scheme.onSurface.withOpacity(0.65),
                          height: 1.45,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        formattedDate,
                        style: TextStyle(
                          fontSize: 12,
                          color: scheme.onSurface.withOpacity(0.4),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
        loading: () =>
            const Center(child: CircularProgressIndicator()),
        error: (e, _) => const EmptyState(
          message: 'Failed to load reflections.',
          icon: Icons.error_outline,
        ),
      ),
    );
  }
}

class _MoodBadge extends StatelessWidget {
  final String mood;
  const _MoodBadge({required this.mood});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: scheme.secondaryContainer.withOpacity(0.5),
        borderRadius: BorderRadius.circular(50),
      ),
      child: Text(
        mood,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: scheme.onSecondaryContainer,
        ),
      ),
    );
  }
}
