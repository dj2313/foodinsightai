import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:mealplanner/src/common/providers/pantry_provider.dart';
import 'package:mealplanner/src/common/providers/scan_provider.dart';

void main() {
  test('addFromScan adds item to pantry', () {
    final container = ProviderContainer();
    addTearDown(container.dispose);

    final initialLength = container.read(pantryProvider).length;
    final scan = container.read(scanResultProvider);
    container.read(pantryProvider.notifier).addFromScan(scan);

    final updated = container.read(pantryProvider);
    expect(updated.length, initialLength + 1);
    expect(updated.last.name, scan.name);
  });
}

