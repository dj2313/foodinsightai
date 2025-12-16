import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import '../../ai/vision_service.dart';
import '../providers/pantry_provider.dart';
import '../toast.dart';

class ScanFab extends ConsumerStatefulWidget {
  const ScanFab({super.key});

  @override
  ConsumerState<ScanFab> createState() => _ScanFabState();
}

class _ScanFabState extends ConsumerState<ScanFab> {
  final ImagePicker _picker = ImagePicker();
  bool _isLoading = false;

  Future<void> _handleScan() async {
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
      final XFile? image = await _picker.pickImage(source: source);
      if (image == null) return;

      setState(() => _isLoading = true);
      AppToast.show('Analyzing image with Gemini...');

      final items = await ref.read(visionServiceProvider).analyzeImage(image);

      if (items.isEmpty) {
        AppToast.show('No food items identified.');
      } else {
        // Add to pantry
        // Note: We need a method in PantryProvider to add multiple items.
        // For now we add one by one or we need to update provider.
        // Assuming add(item) exists.
        final notifier = ref.read(pantryProvider.notifier);
        for (var item in items) {
          notifier.addItem(item);
        }

        AppToast.show('Success! Added ${items.length} items to Pantry.');

        // Optional: Navigate to Pantry Screen
        // Navigator.of(context).pushNamedAndRemoveUntil('/pantry', (_) => false);
      }
    } catch (e) {
      AppToast.show('Error: $e');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Container(
        width: 72,
        height: 72,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white,
          boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10)],
        ),
        child: const Center(child: CircularProgressIndicator(strokeWidth: 3)),
      );
    }

    return Container(
      width: 72,
      height: 72,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          colors: [Color(0xFFFF9100), Color(0xFFFF5E00)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: Color(0x66FF7A00),
            blurRadius: 18,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(36),
          onTap: _handleScan,
          child: const Center(
            child: Icon(Icons.qr_code_scanner, color: Colors.white, size: 30),
          ),
        ),
      ),
    );
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
