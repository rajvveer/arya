import 'package:flutter/material.dart';
import '../../../data/models/ambience.dart';
import '../../../core/theme/app_theme.dart';

class AmbienceCard extends StatelessWidget {
  final Ambience ambience;
  final VoidCallback onTap;

  const AmbienceCard({
    super.key,
    required this.ambience,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return GestureDetector(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Container(
          decoration: BoxDecoration(
            color: scheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Stack(
            fit: StackFit.expand,
            children: [
              // Image
              Image.asset(
                ambience.imageAsset,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => _fallbackGradient(ambience.tag),
              ),
              // Gradient overlay
              DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withOpacity(0.75),
                    ],
                    stops: const [0.4, 1.0],
                  ),
                ),
              ),
              // Content
              Padding(
                padding: const EdgeInsets.all(14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    _TagChip(tag: ambience.tag),
                    const SizedBox(height: 6),
                    Text(
                      ambience.title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        height: 1.2,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(Icons.schedule, color: Colors.white54, size: 12),
                        const SizedBox(width: 4),
                        Text(
                          ambience.formattedDuration,
                          style: const TextStyle(color: Colors.white54, fontSize: 12),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _fallbackGradient(String tag) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: _gradientColors(tag),
        ),
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

class _TagChip extends StatelessWidget {
  final String tag;
  const _TagChip({required this.tag});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: AppTheme.tagColor(tag).withOpacity(0.85),
        borderRadius: BorderRadius.circular(50),
      ),
      child: Text(
        tag,
        style: TextStyle(
          color: AppTheme.tagTextColor(tag),
          fontSize: 11,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
