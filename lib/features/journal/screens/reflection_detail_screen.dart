import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../providers/journal_provider.dart';

class ReflectionDetailScreen extends ConsumerWidget {
  final String entryId;
  const ReflectionDetailScreen({super.key, required this.entryId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scheme = Theme.of(context).colorScheme;
    final entry = ref.read(journalProvider.notifier).getEntry(entryId);

    if (entry == null) {
      return Scaffold(
        appBar: AppBar(leading: BackButton()),
        body: const Center(child: Text('Entry not found')),
      );
    }

    final formattedDate =
        DateFormat('EEEE, MMMM d yyyy · h:mm a').format(entry.createdAt.toLocal());

    return Scaffold(
      appBar: AppBar(
        title: const Text('Reflection'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header card
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    scheme.primaryContainer.withOpacity(0.4),
                    scheme.secondaryContainer.withOpacity(0.3),
                  ],
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          entry.ambienceTitle,
                          style: const TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 18,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          formattedDate,
                          style: TextStyle(
                            fontSize: 13,
                            color: scheme.onSurface.withOpacity(0.5),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: scheme.secondaryContainer,
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: Text(
                      entry.mood,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                        color: scheme.onSecondaryContainer,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 28),
            Text(
              'What was gently present',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: scheme.onSurface.withOpacity(0.45),
                letterSpacing: 0.4,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              entry.text,
              style: TextStyle(
                fontSize: 16,
                height: 1.75,
                color: scheme.onSurface.withOpacity(0.85),
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
