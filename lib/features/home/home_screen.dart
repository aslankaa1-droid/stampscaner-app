import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/i18n/translations.dart';
import '../../core/theme/app_colors.dart';

/// Bottom-nav shell wrapping the five primary branches.
class HomeShell extends StatelessWidget {
  const HomeShell({super.key, required this.navigationShell});
  final StatefulNavigationShell navigationShell;

  void _go(int index) {
    navigationShell.goBranch(
      index,
      initialLocation: index == navigationShell.currentIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: NavigationBar(
        selectedIndex: navigationShell.currentIndex,
        onDestinationSelected: _go,
        destinations: [
          NavigationDestination(
            icon: const Icon(Icons.home_outlined),
            selectedIcon: const Icon(Icons.home),
            label: context.tr('nav.home'),
          ),
          NavigationDestination(
            icon: const Icon(Icons.center_focus_strong_outlined),
            selectedIcon: const Icon(Icons.center_focus_strong),
            label: context.tr('nav.scanner'),
          ),
          NavigationDestination(
            icon: const Icon(Icons.collections_bookmark_outlined),
            selectedIcon: const Icon(Icons.collections_bookmark),
            label: context.tr('nav.collection'),
          ),
          NavigationDestination(
            icon: const Icon(Icons.chat_outlined),
            selectedIcon: const Icon(Icons.chat),
            label: context.tr('nav.postman'),
          ),
          NavigationDestination(
            icon: const Icon(Icons.person_outline),
            selectedIcon: const Icon(Icons.person),
            label: context.tr('nav.profile'),
          ),
        ],
      ),
    );
  }
}

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('StampScaner'),
        actions: [
          IconButton(
            tooltip: context.tr('profile.settings'),
            onPressed: () => context.go('/profile'),
            icon: const Icon(Icons.settings_outlined),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
        children: [
          _Hero(),
          const SizedBox(height: 32),
          Text(
            context.tr('home.section.quick'),
            style: theme.textTheme.titleMedium,
          ),
          const SizedBox(height: 12),
          _QuickActions(),
          const SizedBox(height: 32),
          Text(
            context.tr('home.section.recent'),
            style: theme.textTheme.titleMedium,
          ),
          const SizedBox(height: 12),
          _RecentEmpty(),
        ],
      ),
    );
  }
}

class _Hero extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            theme.colorScheme.primary,
            theme.colorScheme.primary.withValues(alpha: 0.78),
          ],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            context.tr('home.hero.title'),
            style: theme.textTheme.headlineMedium?.copyWith(
              color: AppColors.cream,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            context.tr('home.hero.subtitle'),
            style: theme.textTheme.bodyLarge?.copyWith(
              color: AppColors.cream.withValues(alpha: 0.88),
            ),
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: FilledButton.icon(
                  onPressed: () => DefaultTabController.of(context).animateTo(1),
                  icon: const Icon(Icons.center_focus_strong),
                  label: Text(context.tr('home.cta.scan')),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _QuickActions extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      childAspectRatio: 1.6,
      children: [
        _QuickTile(
          icon: Icons.center_focus_strong,
          label: context.tr('nav.scanner'),
          onTap: () => context.go('/scanner'),
        ),
        _QuickTile(
          icon: Icons.chat,
          label: context.tr('nav.postman'),
          onTap: () => context.go('/postman'),
        ),
        _QuickTile(
          icon: Icons.verified,
          label: context.tr('identify.actions.certificate'),
          onTap: () => context.push('/certificate'),
        ),
        _QuickTile(
          icon: Icons.collections_bookmark,
          label: context.tr('nav.collection'),
          onTap: () => context.go('/collection'),
        ),
      ],
    );
  }
}

class _QuickTile extends StatelessWidget {
  const _QuickTile({required this.icon, required this.label, required this.onTap});
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Material(
      color: theme.colorScheme.surface,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: theme.colorScheme.outline.withValues(alpha: 0.4),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(icon, color: theme.colorScheme.primary, size: 28),
              Text(
                label,
                style: theme.textTheme.titleMedium,
                maxLines: 2,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _RecentEmpty extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: theme.colorScheme.outline.withValues(alpha: 0.5),
          style: BorderStyle.solid,
        ),
      ),
      child: Column(
        children: [
          Icon(Icons.history, color: theme.colorScheme.outline, size: 40),
          const SizedBox(height: 12),
          Text(
            context.tr('home.empty.recent'),
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }
}
