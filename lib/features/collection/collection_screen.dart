import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/i18n/translations.dart';
import '../../core/services/storage_service.dart';
import '../../shared/widgets/stamp_card.dart';

final _collectionFutureProvider =
    FutureProvider.autoDispose<List<StoredStamp>>((ref) async {
  return ref.read(storageServiceProvider).list();
});

final _totalProvider = FutureProvider.autoDispose<int>((ref) async {
  return ref.read(storageServiceProvider).totalEstimateMidpoint();
});

class CollectionScreen extends ConsumerWidget {
  const CollectionScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final list = ref.watch(_collectionFutureProvider);
    final total = ref.watch(_totalProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(context.tr('collection.title')),
        actions: [
          IconButton(
            onPressed: () {
              ref.invalidate(_collectionFutureProvider);
              ref.invalidate(_totalProvider);
            },
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: list.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text(e.toString())),
        data: (items) {
          if (items.isEmpty) return _EmptyState();
          return RefreshIndicator(
            onRefresh: () async {
              ref.invalidate(_collectionFutureProvider);
              ref.invalidate(_totalProvider);
            },
            child: ListView.separated(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
              itemCount: items.length + 1,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                if (index == 0) {
                  return total.maybeWhen(
                    data: (sum) => _TotalBanner(total: sum, count: items.length),
                    orElse: () => const SizedBox.shrink(),
                  );
                }
                final stamp = items[index - 1];
                return Dismissible(
                  key: ValueKey(stamp.id),
                  direction: DismissDirection.endToStart,
                  background: Container(
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.only(right: 24),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      color: theme.colorScheme.errorContainer,
                    ),
                    child: const Icon(Icons.delete_outline),
                  ),
                  onDismissed: (_) async {
                    await ref.read(storageServiceProvider).remove(stamp.id);
                    ref.invalidate(_collectionFutureProvider);
                    ref.invalidate(_totalProvider);
                  },
                  child: StampCard(stamp: stamp),
                );
              },
            ),
          );
        },
      ),
    );
  }
}

class _TotalBanner extends StatelessWidget {
  const _TotalBanner({required this.total, required this.count});
  final int total;
  final int count;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: theme.colorScheme.primary.withValues(alpha: 0.08),
        border: Border.all(
          color: theme.colorScheme.primary.withValues(alpha: 0.25),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  context.tr('collection.total.value'),
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '\$$total',
                  style: theme.textTheme.headlineSmall?.copyWith(
                    color: theme.colorScheme.primary,
                  ),
                ),
              ],
            ),
          ),
          Text(
            '$count ${context.tr('collection.items')}',
            style: theme.textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.collections_bookmark_outlined,
                size: 72, color: theme.colorScheme.outline),
            const SizedBox(height: 16),
            Text(
              context.tr('collection.empty.title'),
              style: theme.textTheme.titleLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              context.tr('collection.empty.body'),
              style: theme.textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () => context.go('/scanner'),
              icon: const Icon(Icons.center_focus_strong),
              label: Text(context.tr('collection.empty.cta')),
            ),
          ],
        ),
      ),
    );
  }
}
