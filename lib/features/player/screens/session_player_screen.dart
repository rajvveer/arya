import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/player_provider.dart';

class SessionPlayerScreen extends ConsumerStatefulWidget {
  const SessionPlayerScreen({super.key});

  @override
  ConsumerState<SessionPlayerScreen> createState() =>
      _SessionPlayerScreenState();
}

class _SessionPlayerScreenState extends ConsumerState<SessionPlayerScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _breathController;
  late Animation<double> _breathAnimation;
  bool _hasNavigated = false;

  @override
  void initState() {
    super.initState();
    _breathController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat(reverse: true);

    _breathAnimation = CurvedAnimation(
      parent: _breathController,
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _breathController.dispose();
    super.dispose();
  }

  String _formatDuration(Duration d) {
    final m = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final s = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  @override
  Widget build(BuildContext context) {
    final playerState = ref.watch(playerProvider);

    // Navigate to reflection if session ended
    if (playerState.sessionEnded && !_hasNavigated) {
      _hasNavigated = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) context.pushReplacement('/reflection');
      });
    }

    final ambience = playerState.activeAmbience;

    return Scaffold(
      body: AnimatedBuilder(
        animation: _breathAnimation,
        builder: (context, _) {
          return Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color.lerp(
                    const Color(0xFF0D2B3E),
                    const Color(0xFF1A4A5A),
                    _breathAnimation.value,
                  )!,
                  Color.lerp(
                    const Color(0xFF1A2B4A),
                    const Color(0xFF0D3B30),
                    _breathAnimation.value,
                  )!,
                  Color.lerp(
                    const Color(0xFF2A1A3A),
                    const Color(0xFF3A2B1A),
                    _breathAnimation.value,
                  )!,
                ],
                stops: const [0.0, 0.5, 1.0],
              ),
            ),
            child: SafeArea(
              child: Column(
                children: [
                  // Top bar
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          onPressed: () => context.pop(),
                          icon: const Icon(Icons.keyboard_arrow_down_rounded,
                              color: Colors.white70, size: 32),
                        ),
                        Text(
                          'Session',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.7),
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        IconButton(
                          onPressed: () => _showEndDialog(context),
                          icon: const Icon(Icons.stop_circle_outlined,
                              color: Colors.white54),
                        ),
                      ],
                    ),
                  ),

                  const Spacer(flex: 2),

                  // Breathing orb
                  TweenAnimationBuilder<double>(
                    tween: Tween(begin: 0.85, end: 1.0),
                    duration: const Duration(seconds: 4),
                    curve: Curves.easeInOut,
                    builder: (context, scale, _) {
                      return Transform.scale(
                        scale: 0.85 +
                            (_breathAnimation.value * 0.15),
                        child: Container(
                          width: 200,
                          height: 200,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: RadialGradient(
                              colors: [
                                Colors.white.withOpacity(
                                    0.1 + _breathAnimation.value * 0.08),
                                Colors.transparent,
                              ],
                            ),
                            border: Border.all(
                              color: Colors.white.withOpacity(
                                  0.15 + _breathAnimation.value * 0.1),
                              width: 1,
                            ),
                          ),
                          child: Center(
                            child: Icon(
                              Icons.spa_outlined,
                              size: 56,
                              color: Colors.white
                                  .withOpacity(0.5 + _breathAnimation.value * 0.3),
                            ),
                          ),
                        ),
                      );
                    },
                  ),

                  const Spacer(flex: 1),

                  // Ambience info
                  if (ambience != null) ...[
                    Text(
                      ambience.title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                        letterSpacing: -0.3,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      ambience.tag,
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.5),
                        fontSize: 14,
                      ),
                    ),
                  ],

                  const Spacer(flex: 2),

                  // Player controls
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32),
                    child: Column(
                      children: [
                        // Time labels
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              _formatDuration(playerState.elapsed),
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.7),
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Text(
                              _formatDuration(playerState.total),
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.4),
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        // Seek slider
                        SliderTheme(
                          data: SliderTheme.of(context).copyWith(
                            trackHeight: 3,
                            thumbShape: const RoundSliderThumbShape(
                                enabledThumbRadius: 7),
                            activeTrackColor: Colors.white.withOpacity(0.85),
                            inactiveTrackColor: Colors.white.withOpacity(0.2),
                            thumbColor: Colors.white,
                            overlayColor: Colors.white.withOpacity(0.1),
                          ),
                          child: Slider(
                            value: playerState.progress,
                            onChanged: (value) {
                              final target = Duration(
                                seconds:
                                    (value * playerState.total.inSeconds).round(),
                              );
                              ref.read(playerProvider.notifier).seek(target);
                            },
                          ),
                        ),
                        const SizedBox(height: 24),
                        // Play/Pause button
                        GestureDetector(
                          onTap: () {
                            if (playerState.isPlaying) {
                              ref.read(playerProvider.notifier).pause();
                            } else {
                              ref.read(playerProvider.notifier).play();
                            }
                          },
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            width: 72,
                            height: 72,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.white.withOpacity(0.2),
                                  blurRadius: 20,
                                  spreadRadius: 4,
                                ),
                              ],
                            ),
                            child: Icon(
                              playerState.isPlaying
                                  ? Icons.pause_rounded
                                  : Icons.play_arrow_rounded,
                              size: 40,
                              color: const Color(0xFF0D2B3E),
                            ),
                          ),
                        ),
                        const SizedBox(height: 32),
                        // End session
                        TextButton(
                          onPressed: () => _showEndDialog(context),
                          child: Text(
                            'End Session',
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.5),
                              fontSize: 14,
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void _showEndDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('End Session?',
            style: TextStyle(fontWeight: FontWeight.w700)),
        content: const Text(
            'Your progress will be saved and you\'ll be taken to reflection.',
            style: TextStyle(height: 1.5)),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              _endSession();
            },
            child: const Text('End'),
          ),
        ],
      ),
    );
  }

  void _endSession() {
    _hasNavigated = true;
    ref.read(playerProvider.notifier).endSession();
    context.pushReplacement('/reflection');
  }
}
