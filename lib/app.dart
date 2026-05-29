import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/i18n/translations.dart';
import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';
import 'core/services/preferences_controller.dart';

class StampScanerApp extends ConsumerWidget {
  const StampScanerApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final prefs = ref.watch(preferencesControllerProvider);
    final router = ref.watch(appRouterProvider);

    return MaterialApp.router(
      title: 'StampScaner',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme(),
      darkTheme: AppTheme.darkTheme(),
      themeMode: switch (prefs.themeMode) {
        AppThemeMode.light => ThemeMode.light,
        AppThemeMode.sepia => ThemeMode.light, // Sepia treated as a custom light variant.
        AppThemeMode.dark => ThemeMode.dark,
      },
      builder: (context, child) {
        // Apply sepia theme override when selected (works around Material's
        // light/dark binary by swapping the theme at the layer above).
        final isSepia = prefs.themeMode == AppThemeMode.sepia;
        return Theme(
          data: isSepia ? AppTheme.sepiaTheme() : Theme.of(context),
          child: child ?? const SizedBox.shrink(),
        );
      },
      locale: prefs.locale,
      supportedLocales: AppTranslations.supportedLocales,
      localizationsDelegates: const [
        AppTranslationsDelegate(),
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      routerConfig: router,
    );
  }
}
