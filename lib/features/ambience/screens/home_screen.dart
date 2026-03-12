import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/ambience_provider.dart';
import '../../../shared/widgets/ambience_card.dart';
import '../../../shared/widgets/tag_chip.dart';
import '../../../shared/widgets/empty_state.dart';
import '../../../features/player/providers/player_provider.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  static const _tags = ['Focus', 'Calm', 'Sleep', 'Reset'];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filteredAsync = ref.watch(filteredAmbiencesProvider);
    final selectedTag = ref.watch(selectedTagProvider);
    final searchQuery = ref.watch(searchQueryProvider);
    final scheme = Theme.of(context).colorScheme;
    final playerState = ref.watch(playerProvider);
    final hasActiveSession =
        playerState.activeAmbience != null && !playerState.sessionEnded;

    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // Header
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'ArvyaX',
                              style: TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.w700,
                                color: scheme.primary,
                                letterSpacing: -0.5,
                              ),
                            ),
                            Text(
                              'Choose your ambience',
                              style: TextStyle(
                                fontSize: 14,
                                color: scheme.onSurface.withOpacity(0.55),
                              ),
                            ),
                          ],
                        ),
                        IconButton(
                          onPressed: () => context.push('/history'),
                          icon: Icon(Icons.history_rounded, color: scheme.primary),
                          style: IconButton.styleFrom(
                            backgroundColor: scheme.primaryContainer.withOpacity(0.3),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    // Search bar
                    TextField(
                      onChanged: (val) =>
                          ref.read(searchQueryProvider.notifier).state = val,
                      decoration: InputDecoration(
                        hintText: 'Search ambiences...',
                        prefixIcon: Icon(Icons.search_rounded,
                            color: scheme.onSurface.withOpacity(0.4)),
                        suffixIcon: searchQuery.isNotEmpty
                            ? IconButton(
                                icon: const Icon(Icons.clear, size: 18),
                                onPressed: () =>
                                    ref.read(searchQueryProvider.notifier).state = '',
                              )
                            : null,
                      ),
                    ),
                    const SizedBox(height: 14),
                    // Tag chips
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: _tags
                            .map((tag) => Padding(
                                  padding: const EdgeInsets.only(right: 8),
                                  child: TagChip(
                                    tag: tag,
                                    isSelected: selectedTag == tag,
                                    onTap: () {
                                      final notifier = ref.read(selectedTagProvider.notifier);
                                      notifier.state =
                                          notifier.state == tag ? null : tag;
                                    },
                                  ),
                                ))
                            .toList(),
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
            // Grid
            filteredAsync.when(
              data: (ambiences) {
                if (ambiences.isEmpty) {
                  return SliverFillRemaining(
                    child: EmptyState(
                      message: 'No ambiences found.\nTry a different search or filter.',
                      icon: Icons.spa_outlined,
                      buttonLabel: 'Clear Filters',
                      onAction: () {
                        ref.read(searchQueryProvider.notifier).state = '';
                        ref.read(selectedTagProvider.notifier).state = null;
                      },
                    ),
                  );
                }
                return SliverPadding(
                  padding: EdgeInsets.fromLTRB(
                      20, 0, 20, hasActiveSession ? 90 : 20),
                  sliver: SliverGrid(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final ambience = ambiences[index];
                        return AmbienceCard(
                          ambience: ambience,
                          onTap: () => context.push(
                            '/details/${ambience.id}',
                            extra: ambience,
                          ),
                        );
                      },
                      childCount: ambiences.length,
                    ),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount:
                          MediaQuery.of(context).size.width > 500 ? 3 : 2,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      childAspectRatio: 0.78,
                    ),
                  ),
                );
              },
              loading: () => const SliverFillRemaining(
                child: Center(child: CircularProgressIndicator()),
              ),
              error: (e, _) => SliverFillRemaining(
                child: EmptyState(
                  message: 'Failed to load ambiences.',
                  icon: Icons.error_outline,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
