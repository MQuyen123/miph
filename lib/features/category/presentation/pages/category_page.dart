import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/movie_card.dart';
import '../bloc/category_bloc.dart';
import '../bloc/category_event.dart';
import '../bloc/category_state.dart';

class CategoryPage extends StatelessWidget {
  final String type;

  const CategoryPage({super.key, required this.type});

  String get _title {
    switch (type) {
      case 'phim-bo':
        return 'Phim Bộ';
      case 'phim-le':
        return 'Phim Lẻ';
      case 'hoat-hinh':
        return 'Hoạt Hình';
      case 'tv-shows':
        return 'TV Shows';
      default:
        return type;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_title),
      ),
      body: BlocBuilder<CategoryBloc, CategoryState>(
        builder: (context, state) {
          if (state is CategoryLoading || state is CategoryInitial) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            );
          }

          if (state is CategoryError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline,
                      size: 48, color: Colors.white24),
                  const SizedBox(height: 16),
                  Text(state.message,
                      style: const TextStyle(color: Colors.white54)),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: () => context
                        .read<CategoryBloc>()
                        .add(LoadCategoryMovies(type: type)),
                    icon: const Icon(Icons.refresh),
                    label: const Text('Thử lại'),
                  ),
                ],
              ),
            );
          }

          if (state is CategoryLoaded) {
            return _buildContent(context, state);
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildContent(BuildContext context, CategoryLoaded state) {
    return NotificationListener<ScrollNotification>(
      onNotification: (notification) {
        if (notification is ScrollEndNotification &&
            notification.metrics.pixels >=
                notification.metrics.maxScrollExtent - 200) {
          context.read<CategoryBloc>().add(const LoadMoreCategoryMovies());
        }
        return false;
      },
      child: GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          childAspectRatio: 0.6,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
        ),
        itemCount: state.movies.length + (state.isLoadingMore ? 3 : 0),
        itemBuilder: (context, index) {
          if (index >= state.movies.length) {
            return const Center(
              child: CircularProgressIndicator(
                color: AppColors.primary,
                strokeWidth: 2,
              ),
            );
          }
          return MovieCard(movie: state.movies[index]);
        },
      ),
    );
  }
}
