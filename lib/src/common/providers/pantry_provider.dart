import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../auth/auth_providers.dart';
import '../../pantry/data/pantry_repository.dart';
import '../models/pantry_item.dart';
import '../models/scan_result.dart';

/// Provides the active list of pantry items from Firestore.
final pantryProvider = StreamProvider<List<PantryItem>>((ref) {
  final user = ref.watch(authStateChangesProvider).value;
  if (user == null) {
    return Stream.value([]);
  }
  return ref.watch(pantryRepositoryProvider).watchPantry(user.uid);
});

/// Controller for performing actions (add, remove) on the pantry.
final pantryControllerProvider = Provider<PantryController>((ref) {
  return PantryController(ref);
});

class PantryController {
  final Ref _ref;

  PantryController(this._ref);

  Future<void> addItem(PantryItem item) async {
    final user = _ref.read(authStateChangesProvider).value;
    if (user == null) return;
    await _ref.read(pantryRepositoryProvider).addItem(user.uid, item);
  }

  Future<void> addAll(List<PantryItem> items) async {
    final user = _ref.read(authStateChangesProvider).value;
    if (user == null) return;
    final repo = _ref.read(pantryRepositoryProvider);
    // In a real app, use a batch write. For now, sequential add is fine.
    for (final item in items) {
      await repo.addItem(user.uid, item);
    }
  }

  Future<void> removeItem(String id) async {
    final user = _ref.read(authStateChangesProvider).value;
    if (user == null) return;
    await _ref.read(pantryRepositoryProvider).removeItem(user.uid, id);
  }

  Future<void> addFromScan(ScanResult scan) async {
    await addItem(
      PantryItem(
        id: '', // Repository generates specific ID
        name: scan.name,
        quantityLabel: scan.estimatedWeight,
        category: scan.category,
        imageUrl: scan.imageUrl,
        expiry: DateTime.now().add(
          const Duration(days: 7),
        ), // Default freshness
      ),
    );
  }
}
