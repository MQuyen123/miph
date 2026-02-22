import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'core/constants/app_constants.dart';
import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';
import 'injection_container.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // ── Initialize Hive ──
  await Hive.initFlutter();
  await Hive.openBox(AppConstants.favoritesBox);
  await Hive.openBox(AppConstants.watchHistoryBox);
  await Hive.openBox(AppConstants.searchHistoryBox);

  // ── Initialize Dependency Injection ──
  await initDependencies();

  runApp(const MihpApp());
}

class MihpApp extends StatelessWidget {
  const MihpApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812), // iPhone X design size
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MaterialApp.router(
          title: AppConstants.appName,
          debugShowCheckedModeBanner: false,

          // ── Theme ──
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: ThemeMode.dark, // Dark by default
          // ── Router ──
          routerConfig: appRouter,
        );
      },
    );
  }
}
