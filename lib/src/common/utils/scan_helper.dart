import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

import '../../ai/vision_service.dart';
import '../providers/pantry_provider.dart';
import '../toast.dart';

class ScanHelper {
  static Future<void> handleScan(BuildContext context, WidgetRef ref) async {
    final picker = ImagePicker();

    // Show options: Camera or Gallery
    final source = await showModalBottomSheet<ImageSource>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Scan Pantry',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _Option(
                  icon: Icons.camera_alt,
                  label: 'Camera',
                  onTap: () => Navigator.pop(context, ImageSource.camera),
                ),
                _Option(
                  icon: Icons.photo_library,
                  label: 'Gallery',
                  onTap: () => Navigator.pop(context, ImageSource.gallery),
                ),
              ],
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );

    if (source == null) return;

    try {
      final XFile? image = await picker.pickImage(source: source);
      if (image == null) return;

      AppToast.show('Analyzing image with AI...');

      // We don't have a loading state for the UI here since it's a static helper.
      // Ideally we'd show a global loader or toast.

      final items = await ref.read(visionServiceProvider).analyzeImage(image);

      if (items.isEmpty) {
        AppToast.show('No food items identified.');
      } else {
        final controller = ref.read(pantryControllerProvider);
        await controller.addAll(items);
        AppToast.show(
          'Success! Added ${items.length} items to Pantry.',
          type: ToastType.success,
        );
      }
    } catch (e) {
      AppToast.show('Error: $e', type: ToastType.error);
    }
  }
}

class _Option extends StatelessWidget {
  const _Option({required this.icon, required this.label, required this.onTap});
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.withOpacity(0.2)),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Icon(icon, size: 32, color: Theme.of(context).primaryColor),
            const SizedBox(height: 8),
            Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }
}
