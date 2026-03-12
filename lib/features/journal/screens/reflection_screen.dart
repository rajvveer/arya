import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:uuid/uuid.dart';
import '../providers/journal_provider.dart';
import '../../../data/models/journal_entry.dart';
import '../../player/providers/player_provider.dart';

const _moods = ['Calm', 'Grounded', 'Energized', 'Sleepy'];
const _moodIcons = {
  'Calm': Icons.self_improvement,
  'Grounded': Icons.park_outlined,
  'Energized': Icons.bolt_outlined,
  'Sleepy': Icons.bedtime_outlined,
};

class ReflectionScreen extends ConsumerStatefulWidget {
  const ReflectionScreen({super.key});

  @override
  ConsumerState<ReflectionScreen> createState() => _ReflectionScreenState();
}

class _ReflectionScreenState extends ConsumerState<ReflectionScreen> {
  final _controller = TextEditingController();
  String _selectedMood = 'Calm';
  bool _isSaving = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              pinned: true,
              leading: IconButton(
                icon: const Icon(Icons.close),
                onPressed: () {
                  ref.read(playerProvider.notifier).clearSession();
                  context.go('/');
                },
              ),
              title: const Text('Reflection'),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 8, 24, 40),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Prompt
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            scheme.primaryContainer.withOpacity(0.3),
                            scheme.secondaryContainer.withOpacity(0.2),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(Icons.spa_outlined,
                              color: scheme.primary, size: 24),
                          const SizedBox(height: 10),
                          Text(
                            'What is gently present\nwith you right now?',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                              height: 1.4,
                              color: scheme.onSurface,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    // Journal input
                    TextField(
                      controller: _controller,
                      maxLines: 7,
                      minLines: 5,
                      decoration: const InputDecoration(
                        hintText:
                            'Write freely... there are no right answers.',
                        hintStyle: TextStyle(fontStyle: FontStyle.italic),
                        alignLabelWithHint: true,
                      ),
                    ),
                    const SizedBox(height: 24),
                    // Mood selector
                    Text(
                      'How are you feeling?',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: scheme.onSurface.withOpacity(0.6),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: _moods.map((mood) {
                        final isSelected = _selectedMood == mood;
                        return GestureDetector(
                          onTap: () => setState(() => _selectedMood = mood),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 10),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? scheme.primary
                                  : scheme.surfaceContainerHighest,
                              borderRadius: BorderRadius.circular(50),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  _moodIcons[mood],
                                  size: 16,
                                  color: isSelected
                                      ? scheme.onPrimary
                                      : scheme.onSurface.withOpacity(0.6),
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  mood,
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: isSelected
                                        ? scheme.onPrimary
                                        : scheme.onSurface.withOpacity(0.8),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 36),
                    // Save button
                    ElevatedButton(
                      onPressed: _isSaving ? null : _save,
                      child: _isSaving
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Text('Save Reflection'),
                    ),
                    const SizedBox(height: 12),
                    Center(
                      child: TextButton(
                        onPressed: () {
                          ref.read(playerProvider.notifier).clearSession();
                          context.go('/');
                        },
                        child: Text(
                          'Skip for now',
                          style: TextStyle(
                              color: scheme.onSurface.withOpacity(0.4)),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _save() async {
    final playerState = ref.read(playerProvider);
    final ambienceId = playerState.activeAmbience?.id ?? 'unknown';
    final ambienceTitle =
        playerState.activeAmbience?.title ?? 'Unknown Ambience';

    setState(() => _isSaving = true);

    final entry = JournalEntry(
      id: const Uuid().v4(),
      ambienceId: ambienceId,
      ambienceTitle: ambienceTitle,
      mood: _selectedMood,
      text: _controller.text.trim().isEmpty
          ? '(No notes)'
          : _controller.text.trim(),
      createdAt: DateTime.now(),
    );

    await ref.read(journalProvider.notifier).saveEntry(entry);
    ref.read(playerProvider.notifier).clearSession();

    if (mounted) {
      context.go('/history');
    }
  }
}
