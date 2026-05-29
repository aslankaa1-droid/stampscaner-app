import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../core/i18n/translations.dart';
import '../../core/services/api_service.dart';

class ScannerScreen extends ConsumerStatefulWidget {
  const ScannerScreen({super.key});

  @override
  ConsumerState<ScannerScreen> createState() => _ScannerScreenState();
}

class _ScannerScreenState extends ConsumerState<ScannerScreen> {
  bool _busy = false;
  String? _error;

  Future<void> _captureFromCamera() async {
    final granted = await _ensureCameraPermission();
    if (!granted) return;
    await _pickAndIdentify(ImageSource.camera);
  }

  Future<void> _pickFromGallery() async {
    await _pickAndIdentify(ImageSource.gallery);
  }

  Future<bool> _ensureCameraPermission() async {
    final status = await Permission.camera.status;
    if (status.isGranted) return true;
    final result = await Permission.camera.request();
    if (!result.isGranted && mounted) {
      setState(() => _error = context.tr('scanner.permission.body'));
    }
    return result.isGranted;
  }

  Future<void> _pickAndIdentify(ImageSource source) async {
    setState(() {
      _busy = true;
      _error = null;
    });

    try {
      final picker = ImagePicker();
      final file = await picker.pickImage(
        source: source,
        maxWidth: 2400,
        imageQuality: 90,
      );

      if (file == null) {
        setState(() => _busy = false);
        return;
      }

      final api = ref.read(apiServiceProvider);
      final result = await api.identifyStamp(File(file.path));

      if (!mounted) return;
      context.push('/identify',
          extra: result.copyWith(imagePath: file.path));
    } catch (e) {
      if (mounted) setState(() => _error = e.toString());
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(context.tr('scanner.title'))),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
        child: Column(
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: theme.colorScheme.surface,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: theme.colorScheme.outline.withValues(alpha: 0.4),
                  ),
                ),
                child: Center(
                  child: _busy
                      ? Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const CircularProgressIndicator(),
                            const SizedBox(height: 20),
                            Text(
                              context.tr('scanner.processing'),
                              textAlign: TextAlign.center,
                              style: theme.textTheme.bodyMedium,
                            ),
                          ],
                        )
                      : Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.center_focus_strong,
                              size: 80,
                              color: theme.colorScheme.primary
                                  .withValues(alpha: 0.7),
                            ),
                            const SizedBox(height: 20),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 32),
                              child: Text(
                                context.tr('scanner.hint'),
                                textAlign: TextAlign.center,
                                style: theme.textTheme.bodyLarge,
                              ),
                            ),
                          ],
                        ),
                ),
              ),
            ),
            if (_error != null) ...[
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: theme.colorScheme.errorContainer
                      .withValues(alpha: 0.3),
                ),
                child: Text(
                  _error!,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.error,
                  ),
                ),
              ),
            ],
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: _busy ? null : _pickFromGallery,
                    icon: const Icon(Icons.photo_library_outlined),
                    label: Text(context.tr('scanner.fallback.pick')),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  flex: 2,
                  child: ElevatedButton.icon(
                    onPressed: _busy ? null : _captureFromCamera,
                    icon: const Icon(Icons.camera_alt),
                    label: Text(context.tr('scanner.capture')),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
