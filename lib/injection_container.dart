import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get_it/get_it.dart';

import 'core/network/dio_client.dart';
import 'core/network/network_info.dart';

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
  //  DATA SOURCES (sẽ thêm ở Day 2)
  // ══════════════════════════════════════════

  // ══════════════════════════════════════════
  //  REPOSITORIES (sẽ thêm ở Day 2)
  // ══════════════════════════════════════════

  // ══════════════════════════════════════════
  //  USE CASES (sẽ thêm ở Day 3)
  // ══════════════════════════════════════════

  // ══════════════════════════════════════════
  //  BLOCS (sẽ thêm ở Day 3+)
  // ══════════════════════════════════════════
}
