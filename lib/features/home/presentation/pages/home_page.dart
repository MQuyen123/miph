import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/movie_card.dart';
import '../../../../core/widgets/shimmer_loading.dart';
import '../bloc/home_bloc.dart';
import '../bloc/home_event.dart';
import '../bloc/home_state.dart';
import '../widgets/movie_carousel.dart';
import '../widgets/movie_horizontal_list.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'MIHP',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: AppColors.primary,
            fontSize: 24,
            letterSpacing: 2,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () => context.go('/search'),
          ),
          IconButton(
            icon: const Icon(Icons.favorite_border),
            onPressed: () => context.go('/favorites'),
          ),
        ],
      ),
      body: BlocBuilder<HomeBloc, HomeState>(
        builder: (context, state) {
          if (state is HomeLoading || state is HomeInitial) {
            return const HomeShimmer();
          }

          if (state is HomeError) {
            return _ErrorView(
              message: state.message,
              onRetry: () => context.read<HomeBloc>().add(const LoadHomeData()),
            );
          }

          if (state is HomeLoaded) {
            return _HomeContent(state: state);
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}

class _HomeContent extends StatelessWidget {
  final HomeLoaded state;

  const _HomeContent({required this.state});

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      color: AppColors.primary,
      onRefresh: () async {
        context.read<HomeBloc>().add(const RefreshHome());
        // Đợi state chuyển từ Loading sang Loaded
        await context.read<HomeBloc>().stream.firstWhere(
              (s) => s is HomeLoaded || s is HomeError,
            );
      },
      child: NotificationListener<ScrollNotification>(
        onNotification: (notification) {
          if (notification is ScrollEndNotification &&
              notification.metrics.pixels >=
                  notification.metrics.maxScrollExtent - 200) {
            context.read<HomeBloc>().add(const LoadMoreMovies());
          }
          return false;
        },
        child: CustomScrollView(
          slivers: [
            // ── Featured Carousel ──
            if (state.featuredMovies.isNotEmpty)
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.only(top: 12),
                  child: MovieCarousel(movies: state.featuredMovies),
                ),
              ),

            // ── "Phim Mới Cập Nhật" Horizontal List ──
            if (state.movies.length > 5)
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.only(top: 24),
                  child: MovieHorizontalList(
                    title: 'Phim Mới Cập Nhật',
                    movies: state.movies.sublist(5),
                  ),
                ),
              ),

            // ── Category Chips ──
            if (state.categories.isNotEmpty)
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 24, 16, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Thể Loại',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: state.categories.take(12).map((cat) {
                          return ActionChip(
                            label: Text(cat.name),
                            onPressed: () =>
                                context.push('/category/${cat.slug}'),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),
              ),

            // ── Section Title: Tất Cả Phim ──
            const SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.fromLTRB(16, 24, 16, 10),
                child: Text(
                  'Tất Cả Phim',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

            // ── Movie Grid ──
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              sliver: SliverGrid(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    return MovieCard(movie: state.movies[index]);
                  },
                  childCount: state.movies.length,
                ),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  childAspectRatio: 0.6,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
              ),
            ),

            // ── Loading More Indicator ──
            if (state.isLoadingMore)
              const SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.all(24),
                  child: Center(
                    child: CircularProgressIndicator(
                      color: AppColors.primary,
                      strokeWidth: 2,
                    ),
                  ),
                ),
              ),

            // ── Bottom padding ──
            const SliverToBoxAdapter(
              child: SizedBox(height: 24),
            ),
          ],
        ),
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _ErrorView({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.wifi_off_rounded,
              size: 64,
              color: Colors.white24,
            ),
            const SizedBox(height: 16),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white54,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh),
              label: const Text('Thử lại'),
            ),
          ],
        ),
      ),
    );
  }
}
