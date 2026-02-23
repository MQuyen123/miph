import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/movie_card.dart';
import '../bloc/category_bloc.dart';
import '../bloc/category_event.dart';
import '../bloc/category_state.dart';

class CategoryPage extends StatefulWidget {
  final String type;
  final String? initialCategory;

  const CategoryPage({
    super.key,
    required this.type,
    this.initialCategory,
  });

  @override
  State<CategoryPage> createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  late String _selectedType;
  String? _selectedGenre;

  // Loại phim chính
  static const _types = [
    {'slug': 'phim-bo', 'name': 'Phim Bộ', 'icon': Icons.tv},
    {'slug': 'phim-le', 'name': 'Phim Lẻ', 'icon': Icons.movie},
    {'slug': 'hoat-hinh', 'name': 'Hoạt Hình', 'icon': Icons.animation},
    {'slug': 'tv-shows', 'name': 'TV Shows', 'icon': Icons.live_tv},
  ];

  // Thể loại với màu sắc
  static const _genres = [
    {'slug': 'hanh-dong', 'name': 'Hành Động', 'color': 0xFFE53935},
    {'slug': 'tinh-cam', 'name': 'Tình Cảm', 'color': 0xFFE91E63},
    {'slug': 'hai-huoc', 'name': 'Hài Hước', 'color': 0xFFFF9800},
    {'slug': 'co-trang', 'name': 'Cổ Trang', 'color': 0xFF8D6E63},
    {'slug': 'tam-ly', 'name': 'Tâm Lý', 'color': 0xFF9C27B0},
    {'slug': 'hinh-su', 'name': 'Hình Sự', 'color': 0xFF607D8B},
    {'slug': 'chien-tranh', 'name': 'Chiến Tranh', 'color': 0xFF795548},
    {'slug': 'the-thao', 'name': 'Thể Thao', 'color': 0xFF4CAF50},
    {'slug': 'vo-thuat', 'name': 'Võ Thuật', 'color': 0xFFFF5722},
    {'slug': 'vien-tuong', 'name': 'Viễn Tưởng', 'color': 0xFF2196F3},
    {'slug': 'phieu-luu', 'name': 'Phiêu Lưu', 'color': 0xFF009688},
    {'slug': 'khoa-hoc', 'name': 'Khoa Học', 'color': 0xFF3F51B5},
    {'slug': 'kinh-di', 'name': 'Kinh Dị', 'color': 0xFF212121},
    {'slug': 'am-nhac', 'name': 'Âm Nhạc', 'color': 0xFFAB47BC},
    {'slug': 'than-thoai', 'name': 'Thần Thoại', 'color': 0xFF5C6BC0},
    {'slug': 'tai-lieu', 'name': 'Tài Liệu', 'color': 0xFF78909C},
    {'slug': 'bi-an', 'name': 'Bí Ẩn', 'color': 0xFF455A64},
    {'slug': 'phim-18', 'name': '18+', 'color': 0xFFD32F2F},
    {'slug': 'gia-dinh', 'name': 'Gia Đình', 'color': 0xFF66BB6A},
    {'slug': 'chinh-kich', 'name': 'Chính Kịch', 'color': 0xFF7E57C2},
  ];

  @override
  void initState() {
    super.initState();
    _selectedType = widget.type;
    _selectedGenre = widget.initialCategory;
  }

  void _loadMovies() {
    context.read<CategoryBloc>().add(LoadCategoryMovies(
          type: _selectedType,
          category: _selectedGenre,
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Thể Loại'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // ── Type tabs ──
          _buildTypeTabs(),

          // ── Genre chips ──
          _buildGenreChips(),

          const Divider(height: 1, color: Colors.white12),

          // ── Movie grid ──
          Expanded(child: _buildContent()),
        ],
      ),
    );
  }

  Widget _buildTypeTabs() {
    return Container(
      height: 48,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: _types.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final type = _types[index];
          final isSelected = _selectedType == type['slug'];
          return ChoiceChip(
            avatar: Icon(
              type['icon'] as IconData,
              size: 18,
              color: isSelected ? Colors.white : Colors.white54,
            ),
            label: Text(type['name'] as String),
            selected: isSelected,
            selectedColor: AppColors.primary,
            backgroundColor: AppColors.cardDark,
            labelStyle: TextStyle(
              color: isSelected ? Colors.white : Colors.white70,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
            onSelected: (_) {
              setState(() => _selectedType = type['slug'] as String);
              _loadMovies();
            },
          );
        },
      ),
    );
  }

  Widget _buildGenreChips() {
    return Container(
      height: 40,
      margin: const EdgeInsets.only(bottom: 8),
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: _genres.length + 1, // +1 for "Tất cả"
        separatorBuilder: (_, __) => const SizedBox(width: 6),
        itemBuilder: (context, index) {
          if (index == 0) {
            final isSelected = _selectedGenre == null;
            return FilterChip(
              label: const Text('Tất cả'),
              selected: isSelected,
              selectedColor: AppColors.primary,
              backgroundColor: AppColors.surfaceDark,
              checkmarkColor: Colors.white,
              labelStyle: TextStyle(
                color: isSelected ? Colors.white : Colors.white60,
                fontSize: 12,
              ),
              onSelected: (_) {
                setState(() => _selectedGenre = null);
                _loadMovies();
              },
            );
          }

          final genre = _genres[index - 1];
          final genreColor = Color(genre['color'] as int);
          final isSelected = _selectedGenre == genre['slug'];

          return FilterChip(
            label: Text(genre['name'] as String),
            selected: isSelected,
            selectedColor: genreColor,
            backgroundColor: genreColor.withValues(alpha: 0.15),
            checkmarkColor: Colors.white,
            side: BorderSide(
              color:
                  isSelected ? genreColor : genreColor.withValues(alpha: 0.4),
              width: 1,
            ),
            labelStyle: TextStyle(
              color: isSelected ? Colors.white : genreColor,
              fontSize: 12,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
            onSelected: (_) {
              setState(() => _selectedGenre = genre['slug'] as String);
              _loadMovies();
            },
          );
        },
      ),
    );
  }

  Widget _buildContent() {
    return BlocBuilder<CategoryBloc, CategoryState>(
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
                  onPressed: _loadMovies,
                  icon: const Icon(Icons.refresh),
                  label: const Text('Thử lại'),
                ),
              ],
            ),
          );
        }

        if (state is CategoryLoaded) {
          if (state.movies.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.movie_filter, size: 48, color: Colors.white12),
                  SizedBox(height: 16),
                  Text('Không có phim nào',
                      style: TextStyle(color: Colors.white38)),
                ],
              ),
            );
          }
          return _buildGrid(context, state);
        }

        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildGrid(BuildContext context, CategoryLoaded state) {
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
