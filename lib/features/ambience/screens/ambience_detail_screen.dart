import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../data/models/ambience.dart';
import '../../../core/theme/app_theme.dart';
import '../../player/providers/player_provider.dart';

class AmbienceDetailScreen extends ConsumerWidget {
  final Ambience ambience;

  const AmbienceDetailScreen({super.key, required this.ambience});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scheme = Theme.of(context).colorScheme;
    final playerState = ref.watch(playerProvider);
    final hasActiveSession =
        playerState.activeAmbience != null && !playerState.sessionEnded;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 280,
            pinned: true,
            backgroundColor: scheme.surface,
            leading: IconButton(
              onPressed: () => context.pop(),
              icon: Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: Colors.black38,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.arrow_back, color: Colors.white, size: 20),
              ),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Image.asset(
                    ambience.imageAsset,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: _gradientColors(ambience.tag),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          scheme.surface,
                        ],
                        stops: const [0.5, 1.0],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.fromLTRB(24, 0, 24, hasActiveSession ? 100 : 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Tag + duration row
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 5),
                        decoration: BoxDecoration(
                          color: AppTheme.tagColor(ambience.tag),
                          borderRadius: BorderRadius.circular(50),
                        ),
                        child: Text(
                          ambience.tag,
                          style: TextStyle(
                            color: AppTheme.tagTextColor(ambience.tag),
                            fontWeight: FontWeight.w600,
                            fontSize: 12,
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Icon(Icons.schedule,
                          size: 14, color: scheme.onSurface.withOpacity(0.5)),
                      const SizedBox(width: 4),
                      Text(
                        ambience.formattedDuration,
                        style: TextStyle(
                          color: scheme.onSurface.withOpacity(0.5),
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  // Title
                  Text(
                    ambience.title,
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w700,
                      height: 1.2,
                    ),
                  ),
                  const SizedBox(height: 14),
                  // Description
                  Text(
                    ambience.description,
                    style: TextStyle(
                      fontSize: 15,
                      height: 1.6,
                      color: scheme.onSurface.withOpacity(0.75),
                    ),
                  ),
                  const SizedBox(height: 24),
                  // Sensory recipe label
                  Text(
                    'Sensory Recipe',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: scheme.onSurface.withOpacity(0.5),
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: ambience.sensoryRecipes
                        .map((recipe) => _SensoryChip(label: recipe))
                        .toList(),
                  ),
                  const SizedBox(height: 36),
                  // Start Session button
                  ElevatedButton.icon(
                    onPressed: () async {
                      await ref
                          .read(playerProvider.notifier)
                          .startSession(ambience);
                      if (context.mounted) {
                        context.push('/player');
                      }
                    },
                    icon: const Icon(Icons.play_arrow_rounded),
                    label: const Text('Start Session'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<Color> _gradientColors(String tag) {
    switch (tag) {
      case 'Focus':
        return [const Color(0xFF1E4D8C), const Color(0xFF0A2540)];
      case 'Calm':
        return [const Color(0xFF1A6B5A), const Color(0xFF0D3B30)];
      case 'Sleep':
        return [const Color(0xFF3D2970), const Color(0xFF1A0F3A)];
      case 'Reset':
        return [const Color(0xFF8B4A1A), const Color(0xFF3D1F08)];
      default:
        return [const Color(0xFF333333), const Color(0xFF111111)];
    }
  }
}

class _SensoryChip extends StatelessWidget {
  final String label;
  const _SensoryChip({required this.label});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
      decoration: BoxDecoration(
        color: scheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(50),
        border: Border.all(
          color: scheme.outlineVariant.withOpacity(0.5),
        ),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 13,
          color: scheme.onSurface.withOpacity(0.8),
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
