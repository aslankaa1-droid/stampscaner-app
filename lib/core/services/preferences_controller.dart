import 'dart:ui';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../theme/app_theme.dart';

/// User preferences (theme, locale) persisted via SharedPreferences.
class PreferencesState {
  const PreferencesState({
    this.themeMode = AppThemeMode.light,
    this.locale = const Locale('ru'),
  });

  final AppThemeMode themeMode;
  final Locale locale;

  PreferencesState copyWith({AppThemeMode? themeMode, Locale? locale}) =>
      PreferencesState(
        themeMode: themeMode ?? this.themeMode,
        locale: locale ?? this.locale,
      );
}

class PreferencesController extends Notifier<PreferencesState> {
  static const _themeKey = 'stampscaner.theme';
  static const _localeKey = 'stampscaner.locale';

  SharedPreferences? _prefs;

  @override
  PreferencesState build() {
    _load();
    return const PreferencesState();
  }

  Future<void> _load() async {
    _prefs = await SharedPreferences.getInstance();
    final themeRaw = _prefs!.getString(_themeKey);
    final localeRaw = _prefs!.getString(_localeKey);
    state = state.copyWith(
      themeMode: switch (themeRaw) {
        'dark' => AppThemeMode.dark,
        'sepia' => AppThemeMode.sepia,
        _ => AppThemeMode.light,
      },
      locale: localeRaw != null ? Locale(localeRaw) : const Locale('ru'),
    );
  }

  Future<void> setThemeMode(AppThemeMode mode) async {
    state = state.copyWith(themeMode: mode);
    await _prefs?.setString(_themeKey, mode.name);
  }

  Future<void> setLocale(Locale locale) async {
    state = state.copyWith(locale: locale);
    await _prefs?.setString(_localeKey, locale.languageCode);
  }
}

final preferencesControllerProvider =
    NotifierProvider<PreferencesController, PreferencesState>(
  PreferencesController.new,
);
