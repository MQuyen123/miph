import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/movie_card.dart';
import '../bloc/favorite_bloc.dart';
import '../bloc/favorite_event.dart';
import '../bloc/favorite_state.dart';

class FavoritesPage extends StatelessWidget {
  const FavoritesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Yêu thích'),
        centerTitle: true,
      ),
      body: BlocBuilder<FavoriteBloc, FavoriteState>(
        builder: (context, state) {
          if (state is FavoriteInitial) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            );
          }

          if (state is FavoriteLoaded) {
            if (state.movies.isEmpty) {
              return _buildEmpty();
            }
            return _buildGrid(context, state);
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildEmpty() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.favorite_border, size: 64, color: Colors.white12),
          SizedBox(height: 16),
          Text(
            'Chưa có phim yêu thích',
            style: TextStyle(color: Colors.white38, fontSize: 16),
          ),
          SizedBox(height: 8),
          Text(
            'Nhấn ❤️ trên trang chi tiết phim để thêm',
            style: TextStyle(color: Colors.white24, fontSize: 13),
          ),
        ],
      ),
    );
  }

  Widget _buildGrid(BuildContext context, FavoriteLoaded state) {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 0.6,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemCount: state.movies.length,
      itemBuilder: (context, index) {
        final movie = state.movies[index];
        return Dismissible(
          key: Key(movie.slug),
          direction: DismissDirection.endToStart,
          background: Container(
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.only(right: 16),
            decoration: BoxDecoration(
              color: Colors.red.shade700,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.delete, color: Colors.white),
          ),
          onDismissed: (_) {
            context.read<FavoriteBloc>().add(RemoveFavorite(movie.slug));
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Đã xóa "${movie.name}" khỏi yêu thích'),
                duration: const Duration(seconds: 2),
                backgroundColor: AppColors.cardDark,
              ),
            );
          },
          child: MovieCard(movie: movie),
        );
      },
    );
  }
}
