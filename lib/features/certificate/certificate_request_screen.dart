import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/i18n/translations.dart';
import '../../core/models/identification_result.dart';
import '../../core/services/api_service.dart';

class CertificateRequestScreen extends ConsumerStatefulWidget {
  const CertificateRequestScreen({super.key, this.stamp});
  final IdentificationResult? stamp;

  @override
  ConsumerState<CertificateRequestScreen> createState() =>
      _CertificateRequestScreenState();
}

class _CertificateRequestScreenState
    extends ConsumerState<CertificateRequestScreen> {
  String _tier = 'precert';
  final _emailCtrl = TextEditingController();
  final _notesCtrl = TextEditingController();
  bool _busy = false;
  bool _sent = false;

  @override
  void dispose() {
    _emailCtrl.dispose();
    _notesCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_emailCtrl.text.trim().isEmpty) return;
    setState(() => _busy = true);
    final stamp = widget.stamp ?? IdentificationResult.demo();
    await ref.read(apiServiceProvider).requestCertificate(
          stamp: stamp,
          tier: _tier,
          contactEmail: _emailCtrl.text.trim(),
          notes: _notesCtrl.text.trim().isEmpty ? null : _notesCtrl.text.trim(),
        );
    if (!mounted) return;
    setState(() {
      _busy = false;
      _sent = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(context.tr('cert.title'))),
      body: _sent ? _SuccessView() : _buildForm(theme),
    );
  }

  Widget _buildForm(ThemeData theme) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
      children: [
        Text(
          context.tr('cert.intro'),
          style: theme.textTheme.bodyMedium,
        ),
        const SizedBox(height: 24),
        _TierCard(
          selected: _tier == 'precert',
          title: context.tr('cert.tier.precert.title'),
          price: context.tr('cert.tier.precert.price'),
          body: context.tr('cert.tier.precert.body'),
          accent: false,
          onTap: () => setState(() => _tier = 'precert'),
        ),
        const SizedBox(height: 12),
        _TierCard(
          selected: _tier == 'premium',
          title: context.tr('cert.tier.premium.title'),
          price: context.tr('cert.tier.premium.price'),
          body: context.tr('cert.tier.premium.body'),
          accent: true,
          onTap: () => setState(() => _tier = 'premium'),
        ),
        const SizedBox(height: 24),
        TextField(
          controller: _emailCtrl,
          keyboardType: TextInputType.emailAddress,
          decoration: const InputDecoration(
            labelText: 'E-mail',
          ),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: _notesCtrl,
          maxLines: 3,
          decoration: const InputDecoration(
            labelText: 'Комментарии · Notes',
          ),
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: theme.colorScheme.tertiaryContainer.withValues(alpha: 0.25),
          ),
          child: Row(
            children: [
              Icon(Icons.info_outline,
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.7)),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  context.tr('cert.notice'),
                  style: theme.textTheme.bodySmall,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        ElevatedButton(
          onPressed: _busy ? null : _submit,
          child: _busy
              ? const SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : Text(_tier == 'premium'
                  ? context.tr('cert.cta.premium')
                  : context.tr('cert.cta.precert')),
        ),
      ],
    );
  }
}

class _TierCard extends StatelessWidget {
  const _TierCard({
    required this.selected,
    required this.title,
    required this.price,
    required this.body,
    required this.accent,
    required this.onTap,
  });

  final bool selected;
  final String title, price, body;
  final bool accent;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final borderColor = selected
        ? theme.colorScheme.primary
        : theme.colorScheme.outline.withValues(alpha: 0.4);
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: borderColor, width: selected ? 2 : 1),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(title, style: theme.textTheme.titleMedium),
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: accent
                        ? theme.colorScheme.secondary
                        : theme.colorScheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    price,
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: accent
                          ? Colors.black87
                          : theme.colorScheme.onSurface,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(body, style: theme.textTheme.bodyMedium),
          ],
        ),
      ),
    );
  }
}

class _SuccessView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.check_circle_outline,
                size: 72, color: theme.colorScheme.primary),
            const SizedBox(height: 16),
            Text(
              'Заявка отправлена',
              style: theme.textTheme.titleLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              context.tr('cert.notice'),
              style: theme.textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            OutlinedButton(
              onPressed: () => context.go('/home'),
              child: Text(context.tr('common.close')),
            ),
          ],
        ),
      ),
    );
  }
}
