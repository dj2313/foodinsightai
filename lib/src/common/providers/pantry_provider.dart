import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/pantry_item.dart';
import '../models/scan_result.dart';

final pantryProvider = StateNotifierProvider<PantryNotifier, List<PantryItem>>((
  ref,
) {
  return PantryNotifier(_seedItems);
});

class PantryNotifier extends StateNotifier<List<PantryItem>> {
  PantryNotifier(List<PantryItem> initial) : super(initial);

  void addItem(PantryItem item) {
    state = [...state, item];
  }

  void addAll(List<PantryItem> items) {
    state = [...state, ...items];
  }

  void removeItem(String id) {
    state = state.where((e) => e.id != id).toList();
  }

  void addFromScan(ScanResult scan) {
    addItem(
      PantryItem(
        id: 'scan-${DateTime.now().millisecondsSinceEpoch}',
        name: scan.name,
        quantityLabel: scan.estimatedWeight,
        category: scan.category,
        imageUrl: scan.imageUrl,
        expiry: DateTime.now().add(const Duration(days: 3)),
      ),
    );
  }
}

const _seedItems = <PantryItem>[
  PantryItem(
    id: '1',
    name: 'Avocado',
    quantityLabel: '2 pcs',
    category: 'Fruits',
    imageUrl:
        'https://lh3.googleusercontent.com/aida-public/AB6AXuBSUV3_yLB4N1TIEeWNXsg8BI6QSsq-7ue0qODTZH3Ak-9X00HFeinDb7lDhEPxTfiYRoAzEtS3kfnF6AYHwjpZHEzSbUxaL0tVpqqJJWLFENDA_mZRCs17oNMsk0uxr1pwgVNP13EgtDJj9DKzuY0C7YvPTG4x2lIe0m0d5A9Llk6IACZqrhN_9TtOBtLn2Q7UvpCdp1TzB_03v2ZgRw2ixZDCTJ15vKoYygtcLzvmn618MisydRjubuWHd55gQcsM7pQlqEBFs-hI',
    expiry: null,
  ),
  PantryItem(
    id: '2',
    name: 'Almond Milk',
    quantityLabel: '1 L',
    category: 'Dairy',
    imageUrl:
        'https://lh3.googleusercontent.com/aida-public/AB6AXuD3nd6ZQZ31qu98BhhUBI-GziPWvMvgk1i7BCh4QBh-D-ICU_UYfiqffuLPvryEcYYRhEfoCztgtk1BWhIWBcOvgMBy-y2VqGec7Y-ML7IvGHXkGSrX5zmGsq-ufV6OC9Hrws3C3FlxdKAL5RoCASEP2FOlkfpDGm0YL7cBmcbBye0KdpbI1PjUqqgkNSGcLHqBWpxQTV8rpTsLXx6pGPeWFN4NlJyOi178_doFKFTlUyRoG4C9JOFvmf9EoZKDNoWk7Bxkioh31Y40',
    expiry: null,
  ),
  PantryItem(
    id: '3',
    name: 'Whole Grain Bread',
    quantityLabel: '1 Pack',
    category: 'Bakery',
    imageUrl:
        'https://lh3.googleusercontent.com/aida-public/AB6AXuDfb4d6SCV8ew_bv8ClkLNN9Ta5i7QNl5qB1Ktw8tstypfvjkB-NnACnhIVKRksFwtGiB-f5Ak1rx55Nf1iwvjvwsb_GEMiAGvLatuCjfbYd3nCdiLG0rGOD4nY0JOwgTqPSkFSDzECxVJjzWDsgKAebdV6QTPrVq7Gc3erLWsSzlMCxPmiNEB9Wm6bSVsvMbkMUrNbmdXxITLMpHh6TmXgSgBJfNCVZQ7JFSn1rYy40g1qJ8txh6PoJeTlU7Hsr9Y5I61oH-wlV1FY',
    expiry: null,
  ),
  PantryItem(
    id: '4',
    name: 'Spinach',
    quantityLabel: '300 g',
    category: 'Vegetables',
    imageUrl:
        'https://lh3.googleusercontent.com/aida-public/AB6AXuAgkXz2HKwycOUPv7qQDXWNL1fKNu55sHphpz-NeHcWXV1xOhnkLR2yMCQ-x6pReRCTNXs6EYltlmrYDbshP3MFnkxDX2SMhzGgUVA5-f-TqdjobQv6glMQzgaMbddAJ7SCSuYI11oMXwTGbVTPOoJQv2BIovW5ab3w39H2CmpQ_RsJJXJ07grAh8_tGzoQMwiu-6gRkMmwC1XIp5drJoPTXVsbE71mV7J8x8TsSUdo39GZiioTWkYDLla47ZjCFMK2G_Nclpafge9T',
    expiry: null,
  ),
  PantryItem(
    id: '5',
    name: 'Apples',
    quantityLabel: '6 pcs',
    category: 'Fruits',
    imageUrl:
        'https://lh3.googleusercontent.com/aida-public/AB6AXuA8nlc5pSPUg7_ZKhP9YZsyHwa6hCJDLM2T5s0k7vNpar55LDwV_II2lsSHnZJiuD77sHajNVAPZwiAB3urjRZwlp0cKv3LN0PS4HSMfVL6uZnY1LjfLKkOf8J125F2AQDrpSjSVsulDY_xLUWPj2381IbfCRcfoR07YKg_iIPsKcNMvL6uMuOW-H5cfrGCZgQVXiCvzqR-XeexaWZs8qaugo-mfZg0x1W0ga5MJbx7ddQZPnXlqDRP8Zpnu8wwtedCXYH6-3Q1XdzY',
    expiry: null,
  ),
];
