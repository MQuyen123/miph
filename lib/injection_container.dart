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
import 'features/movie_detail/data/repositories/movie_detail_repository_impl.dart';
import 'features/movie_detail/domain/repositories/movie_detail_repository.dart';
import 'features/search/data/repositories/search_repository_impl.dart';
import 'features/search/domain/repositories/search_repository.dart';

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

  // ══════════════════════════════════════════
  //  BLOCS
  // ══════════════════════════════════════════

  sl.registerFactory(() => HomeBloc(
        getNewMovies: sl<GetNewMovies>(),
        getCategories: sl<GetCategories>(),
      ));
}
