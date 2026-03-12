import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../features/ambience/screens/home_screen.dart';
import '../../features/ambience/screens/ambience_detail_screen.dart';
import '../../features/player/screens/session_player_screen.dart';
import '../../features/journal/screens/reflection_screen.dart';
import '../../features/journal/screens/history_screen.dart';
import '../../features/journal/screens/reflection_detail_screen.dart';
import '../../data/models/ambience.dart';
import '../../features/player/providers/player_provider.dart';
import '../../features/player/widgets/mini_player_widget.dart';

final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/',
    routes: [
      ShellRoute(
        builder: (context, state, child) {
          return _ShellScaffold(child: child);
        },
        routes: [
          GoRoute(
            path: '/',
            builder: (context, state) => const HomeScreen(),
          ),
          GoRoute(
            path: '/details/:id',
            builder: (context, state) {
              final ambience = state.extra as Ambience;
              return AmbienceDetailScreen(ambience: ambience);
            },
          ),
          GoRoute(
            path: '/history',
            builder: (context, state) => const HistoryScreen(),
          ),
          GoRoute(
            path: '/history/:id',
            builder: (context, state) {
              final entryId = state.pathParameters['id']!;
              return ReflectionDetailScreen(entryId: entryId);
            },
          ),
        ],
      ),
      GoRoute(
        path: '/player',
        builder: (context, state) => const SessionPlayerScreen(),
      ),
      GoRoute(
        path: '/reflection',
        builder: (context, state) => const ReflectionScreen(),
      ),
    ],
  );
});

class _ShellScaffold extends ConsumerWidget {
  final Widget child;
  const _ShellScaffold({required this.child});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final playerState = ref.watch(playerProvider);
    final hasActiveSession = playerState.activeAmbience != null &&
        !playerState.sessionEnded;

    return Stack(
      children: [
        child,
        if (hasActiveSession)
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: const MiniPlayerWidget(),
          ),
      ],
    );
  }
}
