import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/i18n/translations.dart';
import '../../core/services/preferences_controller.dart';
import '../../core/theme/app_theme.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final prefs = ref.watch(preferencesControllerProvider);
    final controller = ref.read(preferencesControllerProvider.notifier);

    return Scaffold(
      appBar: AppBar(title: Text(context.tr('profile.title'))),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
        children: [
          _UserCard(),
          const SizedBox(height: 24),
          _SectionHeader(context.tr('profile.settings')),
          _ThemePicker(
            value: prefs.themeMode,
            onChanged: controller.setThemeMode,
          ),
          const SizedBox(height: 12),
          _LanguagePicker(
            value: prefs.locale,
            onChanged: controller.setLocale,
          ),
          const SizedBox(height: 24),
          _SectionHeader(context.tr('profile.about')),
          _LinkRow(
            icon: Icons.description_outlined,
            label: context.tr('profile.legal.terms'),
            url: 'https://stampscaner.com/terms.html',
          ),
          _LinkRow(
            icon: Icons.privacy_tip_outlined,
            label: context.tr('profile.legal.privacy'),
            url: 'https://stampscaner.com/privacy.html',
          ),
          _LinkRow(
            icon: Icons.verified_outlined,
            label: context.tr('profile.legal.registry'),
            url: 'https://stampscaner.com/cert/',
          ),
          _LinkRow(
            icon: Icons.email_outlined,
            label: context.tr('profile.contact'),
            url: 'mailto:aslankaa@yandex.ru',
          ),
          const SizedBox(height: 24),
          Center(
            child: Text(
              '${context.tr('profile.version')} 0.1.0',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _UserCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: theme.colorScheme.surface,
        border: Border.all(
          color: theme.colorScheme.outline.withValues(alpha: 0.4),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 28,
            backgroundColor:
                theme.colorScheme.primary.withValues(alpha: 0.15),
            child: Icon(Icons.person, color: theme.colorScheme.primary),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(context.tr('profile.guest'),
                    style: theme.textTheme.titleMedium),
                const SizedBox(height: 2),
                Text(
                  context.tr('profile.signIn'),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.primary,
                    fontSize: 13,
                    height: 1.2,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Icon(Icons.chevron_right,
              color: theme.colorScheme.onSurface.withValues(alpha: 0.4)),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader(this.label);
  final String label;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(4, 8, 0, 10),
      child: Text(
        label.toUpperCase(),
        style: theme.textTheme.labelSmall?.copyWith(
          color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
          letterSpacing: 0.12,
        ),
      ),
    );
  }
}

class _ThemePicker extends StatelessWidget {
  const _ThemePicker({required this.value, required this.onChanged});
  final AppThemeMode value;
  final ValueChanged<AppThemeMode> onChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    Widget tile(AppThemeMode mode, IconData icon, String label) {
      final selected = value == mode;
      return Expanded(
        child: InkWell(
          onTap: () => onChanged(mode),
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
              color: selected
                  ? theme.colorScheme.primary.withValues(alpha: 0.1)
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: selected
                    ? theme.colorScheme.primary
                    : theme.colorScheme.outline.withValues(alpha: 0.3),
                width: selected ? 2 : 1,
              ),
            ),
            child: Column(
              children: [
                Icon(icon,
                    color: selected
                        ? theme.colorScheme.primary
                        : theme.colorScheme.onSurface),
                const SizedBox(height: 6),
                Text(label, style: theme.textTheme.bodySmall),
              ],
            ),
          ),
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: theme.colorScheme.outline.withValues(alpha: 0.4),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
            child: Text(context.tr('profile.theme'),
                style: theme.textTheme.titleSmall),
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              tile(AppThemeMode.light, Icons.light_mode,
                  context.tr('profile.theme.light')),
              const SizedBox(width: 8),
              tile(AppThemeMode.sepia, Icons.book_outlined,
                  context.tr('profile.theme.sepia')),
              const SizedBox(width: 8),
              tile(AppThemeMode.dark, Icons.dark_mode,
                  context.tr('profile.theme.dark')),
            ],
          ),
        ],
      ),
    );
  }
}

class _LanguagePicker extends StatelessWidget {
  const _LanguagePicker({required this.value, required this.onChanged});
  final Locale value;
  final ValueChanged<Locale> onChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final options = [
      ('ru', 'Русский'),
      ('en', 'English'),
      ('ar', 'العربية'),
    ];
    return Container(
      padding: const EdgeInsets.fromLTRB(14, 12, 14, 6),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: theme.colorScheme.outline.withValues(alpha: 0.4),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 4, bottom: 8),
            child: Text(context.tr('profile.language'),
                style: theme.textTheme.titleSmall),
          ),
          ...options.map((o) {
            final selected = value.languageCode == o.$1;
            return InkWell(
              onTap: () => onChanged(Locale(o.$1)),
              borderRadius: BorderRadius.circular(8),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 6, vertical: 10),
                child: Row(
                  children: [
                    Icon(
                      selected
                          ? Icons.radio_button_checked
                          : Icons.radio_button_off,
                      color: selected
                          ? theme.colorScheme.primary
                          : theme.colorScheme.outline,
                      size: 20,
                    ),
                    const SizedBox(width: 12),
                    Text(o.$2, style: theme.textTheme.bodyLarge),
                  ],
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}

class _LinkRow extends StatelessWidget {
  const _LinkRow({required this.icon, required this.label, required this.url});
  final IconData icon;
  final String label;
  final String url;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(icon, color: theme.colorScheme.primary),
      title: Text(label, style: theme.textTheme.bodyLarge),
      trailing: Icon(Icons.open_in_new,
          color: theme.colorScheme.onSurface.withValues(alpha: 0.4)),
      onTap: () {
        // Sprint 1.5 will wire url_launcher; for now we just expose the URL.
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(url),
            behavior: SnackBarBehavior.floating,
          ),
        );
      },
    );
  }
}
