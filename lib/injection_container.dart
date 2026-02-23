import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get_it/get_it.dart';

import 'core/network/dio_client.dart';
import 'core/network/network_info.dart';
import 'features/home/data/datasources/movie_remote_datasource.dart';
import 'features/home/data/datasources/movie_remote_datasource_impl.dart';
import 'features/home/data/repositories/home_repository_impl.dart';
import 'features/home/domain/repositories/home_repository.dart';
import 'features/home/domain/usecases/get_categories.dart';
import 'features/home/domain/usecases/get_new_movies.dart';
import 'features/home/presentation/bloc/home_bloc.dart';
import 'features/category/presentation/bloc/category_bloc.dart';
import 'features/movie_detail/data/repositories/movie_detail_repository_impl.dart';
import 'features/movie_detail/domain/repositories/movie_detail_repository.dart';
import 'features/movie_detail/domain/usecases/get_movie_detail.dart';
import 'features/movie_detail/presentation/bloc/movie_detail_bloc.dart';
import 'features/search/data/repositories/search_repository_impl.dart';
import 'features/search/domain/repositories/search_repository.dart';
import 'features/search/domain/usecases/get_movies_by_type.dart';
import 'features/search/domain/usecases/search_movies.dart';
import 'features/search/presentation/bloc/search_bloc.dart';

/// Global service locator instance.
final sl = GetIt.instance;

/// Initialize all dependencies.
/// Call this in main() before runApp().
Future<void> initDependencies() async {
  // ══════════════════════════════════════════
  //  CORE
  // ══════════════════════════════════════════

  // Dio Client
  sl.registerLazySingleton<DioClient>(() => DioClient());

  // Network Info
  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(Connectivity()));

  // ══════════════════════════════════════════
  //  DATA SOURCES
  // ══════════════════════════════════════════

  sl.registerLazySingleton<MovieRemoteDataSource>(
    () => MovieRemoteDataSourceImpl(sl<DioClient>()),
  );

  // ══════════════════════════════════════════
  //  REPOSITORIES
  // ══════════════════════════════════════════

  sl.registerLazySingleton<HomeRepository>(
    () => HomeRepositoryImpl(
      remoteDataSource: sl<MovieRemoteDataSource>(),
      networkInfo: sl<NetworkInfo>(),
    ),
  );

  sl.registerLazySingleton<MovieDetailRepository>(
    () => MovieDetailRepositoryImpl(
      remoteDataSource: sl<MovieRemoteDataSource>(),
      networkInfo: sl<NetworkInfo>(),
    ),
  );

  sl.registerLazySingleton<SearchRepository>(
    () => SearchRepositoryImpl(
      remoteDataSource: sl<MovieRemoteDataSource>(),
      networkInfo: sl<NetworkInfo>(),
    ),
  );

  // ══════════════════════════════════════════
  //  USE CASES
  // ══════════════════════════════════════════

  sl.registerLazySingleton(() => GetNewMovies(sl<HomeRepository>()));
  sl.registerLazySingleton(() => GetCategories(sl<HomeRepository>()));
  sl.registerLazySingleton(() => GetMovieDetail(sl<MovieDetailRepository>()));
  sl.registerLazySingleton(() => SearchMovies(sl<SearchRepository>()));
  sl.registerLazySingleton(() => GetMoviesByType(sl<SearchRepository>()));

  // ══════════════════════════════════════════
  //  BLOCS
  // ══════════════════════════════════════════

  sl.registerFactory(() => HomeBloc(
        getNewMovies: sl<GetNewMovies>(),
        getCategories: sl<GetCategories>(),
      ));

  sl.registerFactory(() => MovieDetailBloc(
        getMovieDetail: sl<GetMovieDetail>(),
      ));

  sl.registerFactory(() => SearchBloc(
        searchMovies: sl<SearchMovies>(),
      ));

  sl.registerFactory(() => CategoryBloc(
        getMoviesByType: sl<GetMoviesByType>(),
      ));
}
