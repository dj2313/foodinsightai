import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mealplanner/src/auth/auth_providers.dart';
import 'package:mealplanner/src/common/models/pantry_item.dart';
import 'package:mealplanner/src/common/providers/pantry_provider.dart';
import 'package:mealplanner/src/common/providers/scan_provider.dart';
import 'package:mealplanner/src/pantry/data/pantry_repository.dart';

// Fake User to mimic authenticated user
class FakeUser extends Fake implements User {
  @override
  final String uid = 'test_uid';
}

// Mock Repository
class MockPantryRepository implements PantryRepository {
  final _controller = StreamController<List<PantryItem>>.broadcast();
  List<PantryItem> _items = [];

  MockPantryRepository() {
    // Initial emission
    Future.microtask(() => _controller.add(_items));
  }

  @override
  Future<void> addItem(String uid, PantryItem item) async {
    _items = [..._items, item];
    _controller.add(_items);
  }

  @override
  Stream<List<PantryItem>> watchPantry(String uid) {
    return _controller.stream;
  }

  @override
  Future<void> updateItem(String uid, PantryItem item) async {
    // No-op for this test
  }

  @override
  Future<void> removeItem(String uid, String itemId) async {
    // No-op for this test
  }
}

void main() {
  test('addFromScan adds item to pantry', () async {
    final mockRepo = MockPantryRepository();
    final fakeUser = FakeUser();

    final container = ProviderContainer(
      overrides: [
        pantryRepositoryProvider.overrideWithValue(mockRepo),
        authStateChangesProvider.overrideWith((ref) => Stream.value(fakeUser)),
      ],
    );
    addTearDown(container.dispose);

    // 1. Verify initial state (empty)
    // We wait for the first value from the stream
    final initialList = await container.read(pantryProvider.future);
    expect(initialList.length, 0);

    // 2. Perform action
    final scan = container.read(scanResultProvider);
    await container.read(pantryControllerProvider).addFromScan(scan);

    // 3. Verify update
    // We need to wait for the stream provider to process the update.
    // Reading .future again on the provider might just return the cached future if we validly loaded.
    // Instead, we check the current state after a small delay to allow stream propagation.
    await Future.delayed(Duration.zero);

    final updatedState = container.read(pantryProvider);

    expect(updatedState.isLoading, false);
    expect(updatedState.hasError, false);
    expect(updatedState.value, isNotNull);
    expect(updatedState.value!.length, 1);
    expect(updatedState.value!.first.name, scan.name);
  });
}
