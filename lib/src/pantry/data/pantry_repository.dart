import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../auth/auth_providers.dart';
import '../../common/models/pantry_item.dart';

final pantryRepositoryProvider = Provider<PantryRepository>((ref) {
  return PantryRepository(ref.watch(firestoreProvider));
});

class PantryRepository {
  final FirebaseFirestore _firestore;

  PantryRepository(this._firestore);

  Stream<List<PantryItem>> watchPantry(String uid) {
    return _firestore
        .collection('users')
        .doc(uid)
        .collection('pantry')
        .orderBy('expiry')
        .snapshots()
        .map((snapshot) {
          return snapshot.docs.map((doc) {
            return PantryItem.fromMap(doc.data(), doc.id);
          }).toList();
        });
  }

  Future<void> addItem(String uid, PantryItem item) async {
    // If item has no ID (empty), let Firestore generate one,
    // but PantryItem assumes an ID is present.
    // Best practice: if ID is empty, use .add(), else .set().
    // However, our model is immutable.
    // Let's assume we usually add items without IDs and want Firestore ID.
    // But for simplicity in Riverpod, we might generate ID locally (uuid)
    // or let Firestore generate it.

    // Approach: use doc() to get a new ID, then set.
    final ref = _firestore
        .collection('users')
        .doc(uid)
        .collection('pantry')
        .doc(); // Auto-gen ID

    // Create copy with new ID
    final newItem = PantryItem(
      id: ref.id,
      name: item.name,
      category: item.category,
      quantityLabel: item.quantityLabel,
      imageUrl: item.imageUrl,
      expiry: item.expiry,
    );

    await ref.set(newItem.toMap());
  }

  Future<void> updateItem(String uid, PantryItem item) async {
    await _firestore
        .collection('users')
        .doc(uid)
        .collection('pantry')
        .doc(item.id)
        .update(item.toMap());
  }

  Future<void> removeItem(String uid, String itemId) async {
    await _firestore
        .collection('users')
        .doc(uid)
        .collection('pantry')
        .doc(itemId)
        .delete();
  }
}
