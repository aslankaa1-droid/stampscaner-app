import 'dart:io';
import 'package:flutter/material.dart';
import '../../core/services/storage_service.dart';

class StampCard extends StatelessWidget {
  const StampCard({super.key, required this.stamp, this.onTap});
  final StoredStamp stamp;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final r = stamp.result;

    return Material(
      color: theme.colorScheme.surface,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: theme.colorScheme.outline.withValues(alpha: 0.35),
            ),
          ),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: r.imagePath != null && File(r.imagePath!).existsSync()
                    ? Image.file(
                        File(r.imagePath!),
                        width: 72,
                        height: 90,
                        fit: BoxFit.cover,
                      )
                    : Container(
                        width: 72,
                        height: 90,
                        color: theme.colorScheme.surfaceContainerHighest,
                        child: Icon(
                          Icons.image_outlined,
                          color: theme.colorScheme.outline,
                        ),
                      ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${r.country} · ${r.year}',
                      style: theme.textTheme.titleMedium,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      r.series,
                      style: theme.textTheme.bodyMedium,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        _Chip(label: r.grade),
                        const SizedBox(width: 6),
                        _Chip(label: '\$${r.estimateLow}–${r.estimateHigh}',
                            accent: true),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Chip extends StatelessWidget {
  const _Chip({required this.label, this.accent = false});
  final String label;
  final bool accent;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4),
        color: accent
            ? theme.colorScheme.secondary
            : theme.colorScheme.surfaceContainerHighest,
      ),
      child: Text(
        label,
        style: theme.textTheme.labelSmall?.copyWith(
          color: accent ? Colors.black87 : theme.colorScheme.onSurface,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
