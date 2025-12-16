import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/nutrition_info.dart';
import '../models/scan_result.dart';

final scanResultProvider = StateProvider<ScanResult>((ref) {
  return _sampleScan;
});

const _sampleScan = ScanResult(
  id: 'scan1',
  name: 'Tomato',
  category: 'Vegetable',
  imageUrl:
      'https://lh3.googleusercontent.com/aida-public/AB6AXuCO9NrCPIPWeSr34SMENG8qvFpCTgW7eTmmCe1I1RQiwFO9ERAjsgtNKu75nPpYe9r48DYo3IccOIVpE5jgwyzN4xWSrkoTnq6v2Ma6WLXec9nB9mnhzXPA45fzqGuqHAifLA2ljMuJl8WgNRqm3EtJ76-YeRWnnTyBH6nG52Q2sKgd79u8u6MUKUNi_8AImpYa4qC35zHDrl4bvQMdXSC8nAmYHvBk_l5Bsptl-pcEnhdZsYrYMlTrlO1XRwKmtMu_t4NA7DCfkIsE',
  freshnessScore: 0.92,
  estimatedWeight: '~100g',
  shelfLifeLabel: '~2 Days',
  freshnessTip: 'Keep in a cool, dark place away from sunlight. Refrigerate if fully ripe.',
  nutrition: NutritionInfo(
    calories: 18,
    protein: 0.9,
    carbs: 3.9,
    fat: 0.2,
    fiber: 1.2,
    vitaminC: 13,
  ),
  suggestedRecipeIds: ['r1', 'r2'],
);

