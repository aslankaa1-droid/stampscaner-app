import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

enum AppThemeMode { light, sepia, dark }

class AppTheme {
  AppTheme._();

  static ThemeData lightTheme() => _build(
        scheme: ColorScheme.fromSeed(
          seedColor: AppColors.burgundy,
          brightness: Brightness.light,
          primary: AppColors.burgundy,
          secondary: AppColors.gold,
          surface: AppColors.creamElevated,
          surfaceContainerHighest: AppColors.creamDeep,
          onPrimary: AppColors.cream,
          onSecondary: AppColors.ink,
          onSurface: AppColors.ink,
          outline: AppColors.border,
        ),
        bg: AppColors.cream,
        text: AppColors.ink,
        textSoft: AppColors.inkSoft,
      );

  static ThemeData sepiaTheme() => _build(
        scheme: ColorScheme.fromSeed(
          seedColor: AppColors.sepiaBurgundy,
          brightness: Brightness.light,
          primary: AppColors.sepiaBurgundy,
          secondary: AppColors.goldDeep,
          surface: AppColors.sepiaBgElevated,
          surfaceContainerHighest: AppColors.sepiaBgDeep,
          onSurface: AppColors.sepiaText,
          outline: AppColors.border,
        ),
        bg: AppColors.sepiaBg,
        text: AppColors.sepiaText,
        textSoft: AppColors.inkSoft,
      );

  static ThemeData darkTheme() => _build(
        scheme: ColorScheme.fromSeed(
          seedColor: AppColors.burgundySoft,
          brightness: Brightness.dark,
          primary: AppColors.burgundySoft,
          secondary: AppColors.goldSoft,
          surface: AppColors.darkBgElevated,
          surfaceContainerHighest: AppColors.darkBgDeep,
          onSurface: AppColors.darkText,
          outline: AppColors.darkBorder,
        ),
        bg: AppColors.darkBg,
        text: AppColors.darkText,
        textSoft: AppColors.darkTextSoft,
      );

  static ThemeData _build({
    required ColorScheme scheme,
    required Color bg,
    required Color text,
    required Color textSoft,
  }) {
    final base = ThemeData(useMaterial3: true, colorScheme: scheme);
    final serif = GoogleFonts.cormorantGaramondTextTheme(base.textTheme);
    final sans = GoogleFonts.interTextTheme(base.textTheme);

    return base.copyWith(
      scaffoldBackgroundColor: bg,
      brightness: scheme.brightness,
      textTheme: sans.copyWith(
        displayLarge: serif.displayLarge?.copyWith(
          fontWeight: FontWeight.w500,
          letterSpacing: -0.5,
          color: text,
        ),
        displayMedium: serif.displayMedium?.copyWith(
          fontWeight: FontWeight.w500,
          color: text,
        ),
        displaySmall: serif.displaySmall?.copyWith(
          fontWeight: FontWeight.w500,
          color: text,
        ),
        headlineLarge: serif.headlineLarge?.copyWith(
          fontWeight: FontWeight.w500,
          color: text,
        ),
        headlineMedium: serif.headlineMedium?.copyWith(
          fontWeight: FontWeight.w500,
          color: text,
        ),
        headlineSmall: serif.headlineSmall?.copyWith(
          fontWeight: FontWeight.w500,
          color: text,
        ),
        titleLarge: serif.titleLarge?.copyWith(
          fontWeight: FontWeight.w500,
          color: text,
        ),
        titleMedium: sans.titleMedium?.copyWith(
          fontWeight: FontWeight.w600,
          color: text,
        ),
        titleSmall: sans.titleSmall?.copyWith(
          fontWeight: FontWeight.w600,
          color: text,
        ),
        bodyLarge: sans.bodyLarge?.copyWith(color: text, height: 1.55),
        bodyMedium: sans.bodyMedium?.copyWith(color: textSoft, height: 1.55),
        bodySmall: sans.bodySmall?.copyWith(color: textSoft),
        labelLarge: sans.labelLarge?.copyWith(
          fontWeight: FontWeight.w600,
          letterSpacing: 0.1,
          color: text,
        ),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: bg,
        foregroundColor: text,
        elevation: 0,
        scrolledUnderElevation: 0.5,
        centerTitle: false,
        titleTextStyle: serif.titleLarge?.copyWith(
          fontWeight: FontWeight.w600,
          fontSize: 22,
          color: scheme.primary,
        ),
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        color: scheme.surface,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: scheme.outline.withValues(alpha: 0.4)),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: scheme.primary,
          foregroundColor: scheme.onPrimary,
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 16),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          textStyle: sans.labelLarge?.copyWith(
            fontWeight: FontWeight.w600,
            fontSize: 15,
            letterSpacing: 0.1,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: scheme.primary,
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 16),
          side: BorderSide(color: scheme.primary, width: 1.5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          textStyle: sans.labelLarge?.copyWith(fontWeight: FontWeight.w600),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: scheme.secondary,
          foregroundColor: AppColors.ink,
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: scheme.surface,
        indicatorColor: scheme.primary.withValues(alpha: 0.12),
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return sans.labelSmall?.copyWith(
              color: scheme.primary,
              fontWeight: FontWeight.w600,
              fontSize: 10.5,
              letterSpacing: 0,
              height: 1.1,
            );
          }
          return sans.labelSmall?.copyWith(
            color: textSoft,
            fontSize: 10.5,
            letterSpacing: 0,
            height: 1.1,
          );
        }),
        height: 72,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: scheme.surface,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: scheme.outline),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: scheme.outline.withValues(alpha: 0.5)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: scheme.primary, width: 2),
        ),
      ),
      dividerTheme: DividerThemeData(
        color: scheme.outline.withValues(alpha: 0.3),
        thickness: 1,
        space: 1,
      ),
    );
  }
}
