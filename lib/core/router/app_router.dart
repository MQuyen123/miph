import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../features/home/presentation/bloc/home_bloc.dart';
import '../../features/home/presentation/bloc/home_event.dart';
import '../../features/home/presentation/pages/home_page.dart';
import '../../features/movie_detail/presentation/pages/movie_detail_page.dart';
import '../../features/search/presentation/pages/search_page.dart';
import '../../features/category/presentation/pages/category_page.dart';
import '../../features/watch/presentation/pages/watch_page.dart';
import '../../features/favorite/presentation/pages/favorites_page.dart';
import '../../features/history/presentation/pages/history_page.dart';
import '../widgets/main_scaffold.dart';
import '../../injection_container.dart';

/// App route paths.
class AppRoutes {
  AppRoutes._();

  static const String home = '/';
  static const String movieDetail = '/movie/:slug';
  static const String watch = '/watch/:slug/:episode';
  static const String search = '/search';
  static const String category = '/category/:type';
  static const String favorites = '/favorites';
  static const String history = '/history';
}

/// GoRouter configuration.
final GoRouter appRouter = GoRouter(
  initialLocation: AppRoutes.home,
  routes: [
    // ── Shell Route with Bottom Nav ──
    ShellRoute(
      builder: (context, state, child) => MainScaffold(child: child),
      routes: [
        GoRoute(
          path: '/',
          pageBuilder: (context, state) => NoTransitionPage(
            child: BlocProvider(
              create: (_) => sl<HomeBloc>()..add(const LoadHomeData()),
              child: const HomePage(),
            ),
          ),
        ),
        GoRoute(
          path: '/search',
          pageBuilder: (context, state) =>
              const NoTransitionPage(child: SearchPage()),
        ),
        GoRoute(
          path: '/category/:type',
          builder: (context, state) {
            final type = state.pathParameters['type'] ?? 'phim-bo';
            return CategoryPage(type: type);
          },
        ),
        GoRoute(
          path: '/favorites',
          pageBuilder: (context, state) =>
              const NoTransitionPage(child: FavoritesPage()),
        ),
        GoRoute(
          path: '/history',
          pageBuilder: (context, state) =>
              const NoTransitionPage(child: HistoryPage()),
        ),
      ],
    ),
    // ── Full-screen routes (no bottom nav) ──
    GoRoute(
      path: '/movie/:slug',
      builder: (context, state) {
        final slug = state.pathParameters['slug']!;
        return MovieDetailPage(slug: slug);
      },
    ),
    GoRoute(
      path: '/watch/:slug/:episode',
      builder: (context, state) {
        final slug = state.pathParameters['slug']!;
        final episode = state.pathParameters['episode']!;
        return WatchPage(movieSlug: slug, episodeSlug: episode);
      },
    ),
  ],
  errorBuilder: (context, state) => Scaffold(
    body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, size: 64, color: Colors.red),
          const SizedBox(height: 16),
          Text(
            'Trang không tồn tại',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 8),
          ElevatedButton(
            onPressed: () => context.go('/'),
            child: const Text('Về trang chủ'),
          ),
        ],
      ),
    ),
  ),
);
