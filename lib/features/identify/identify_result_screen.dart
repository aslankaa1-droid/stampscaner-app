import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:share_plus/share_plus.dart';
import '../../core/i18n/translations.dart';
import '../../core/models/identification_result.dart';
import '../../core/services/storage_service.dart';

class IdentifyResultScreen extends ConsumerWidget {
  const IdentifyResultScreen({super.key, required this.result});
  final IdentificationResult result;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final confidencePct = (result.confidence * 100).round();

    return Scaffold(
      appBar: AppBar(title: Text(context.tr('identify.title'))),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
        children: [
          if (result.imagePath != null)
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.file(
                File(result.imagePath!),
                height: 220,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
          const SizedBox(height: 20),
          _ConfidenceBar(value: result.confidence, percent: confidencePct),
          const SizedBox(height: 24),
          _ResultCard(
            children: [
              _Row(label: context.tr('identify.country'), value: result.country),
              _Row(label: context.tr('identify.year'), value: '${result.year}'),
              _Row(label: context.tr('identify.series'), value: result.series),
              _Row(label: context.tr('identify.catalog'), value: result.catalogRef),
              _Row(label: context.tr('identify.grade'), value: result.grade),
              _Row(label: context.tr('identify.condition'), value: result.condition),
              _Row(
                label: context.tr('identify.estimate'),
                value: '\$${result.estimateLow}–${result.estimateHigh}',
                accent: true,
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            context.tr('identify.disclaimer'),
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
              height: 1.5,
            ),
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () async {
                    final storage = ref.read(storageServiceProvider);
                    await storage.addStamp(result);
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(context.tr('identify.actions.collection')),
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                    }
                  },
                  icon: const Icon(Icons.bookmark_add_outlined),
                  label: Text(context.tr('identify.actions.collection')),
                ),
              ),
              const SizedBox(width: 10),
              IconButton.filledTonal(
                onPressed: () {
                  Share.share(
                    '${result.country} · ${result.year}\n'
                    '${result.series}\n'
                    'Estimate: \$${result.estimateLow}–${result.estimateHigh}\n'
                    'via StampScaner',
                  );
                },
                icon: const Icon(Icons.share_outlined),
                tooltip: context.tr('identify.actions.share'),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ElevatedButton.icon(
            onPressed: () => context.push('/certificate', extra: result),
            icon: const Icon(Icons.verified),
            label: Text(context.tr('identify.actions.certificate')),
          ),
        ],
      ),
    );
  }
}

class _ConfidenceBar extends StatelessWidget {
  const _ConfidenceBar({required this.value, required this.percent});
  final double value;
  final int percent;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = value >= 0.8
        ? const Color(0xFF5E7C3F)
        : value >= 0.5
            ? const Color(0xFFB86A2C)
            : const Color(0xFFA33124);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              context.tr('identify.confidence'),
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
              ),
            ),
            Text(
              '$percent%',
              style: theme.textTheme.titleMedium?.copyWith(color: color),
            ),
          ],
        ),
        const SizedBox(height: 6),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: value.clamp(0, 1),
            minHeight: 6,
            backgroundColor: theme.colorScheme.surfaceContainerHighest,
            valueColor: AlwaysStoppedAnimation(color),
          ),
        ),
      ],
    );
  }
}

class _ResultCard extends StatelessWidget {
  const _ResultCard({required this.children});
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: theme.colorScheme.outline.withValues(alpha: 0.4),
        ),
      ),
      child: Column(children: children),
    );
  }
}

class _Row extends StatelessWidget {
  const _Row({required this.label, required this.value, this.accent = false});
  final String label;
  final String value;
  final bool accent;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                letterSpacing: 0.04,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              value,
              style: accent
                  ? theme.textTheme.titleMedium?.copyWith(
                      color: theme.colorScheme.primary,
                      fontWeight: FontWeight.w600,
                    )
                  : theme.textTheme.bodyLarge,
              textAlign: TextAlign.end,
            ),
          ),
        ],
      ),
    );
  }
}
