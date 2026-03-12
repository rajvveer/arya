import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/player_provider.dart';

class MiniPlayerWidget extends ConsumerWidget {
  const MiniPlayerWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final playerState = ref.watch(playerProvider);
    final ambience = playerState.activeAmbience;
    if (ambience == null) return const SizedBox.shrink();

    final scheme = Theme.of(context).colorScheme;

    return GestureDetector(
      onTap: () => context.push('/player'),
      child: Container(
        margin: const EdgeInsets.fromLTRB(12, 0, 12, 8),
        decoration: BoxDecoration(
          color: scheme.inverseSurface,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 16,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 8, 12),
              child: Row(
                children: [
                  // Pulse indicator
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: scheme.primary.withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.spa_outlined,
                        size: 18, color: scheme.inversePrimary),
                  ),
                  const SizedBox(width: 12),
                  // Title
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          ambience.title,
                          style: TextStyle(
                            color: scheme.onInverseSurface,
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          playerState.isPlaying ? 'Playing' : 'Paused',
                          style: TextStyle(
                            color: scheme.onInverseSurface.withOpacity(0.55),
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Play/pause button
                  IconButton(
                    onPressed: () {
                      if (playerState.isPlaying) {
                        ref.read(playerProvider.notifier).pause();
                      } else {
                        ref.read(playerProvider.notifier).play();
                      }
                    },
                    icon: Icon(
                      playerState.isPlaying
                          ? Icons.pause_rounded
                          : Icons.play_arrow_rounded,
                      color: scheme.onInverseSurface,
                      size: 28,
                    ),
                  ),
                ],
              ),
            ),
            // Progress bar
            ClipRRect(
              borderRadius: const BorderRadius.vertical(
                  bottom: Radius.circular(18)),
              child: LinearProgressIndicator(
                value: playerState.progress,
                minHeight: 3,
                backgroundColor: scheme.onInverseSurface.withOpacity(0.1),
                valueColor:
                    AlwaysStoppedAnimation<Color>(scheme.inversePrimary),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
