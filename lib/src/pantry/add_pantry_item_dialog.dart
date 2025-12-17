import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../common/models/pantry_item.dart';
import '../common/providers/pantry_provider.dart';

class AddPantryItemDialog extends ConsumerStatefulWidget {
  const AddPantryItemDialog({super.key});

  @override
  ConsumerState<AddPantryItemDialog> createState() =>
      _AddPantryItemDialogState();
}

class _AddPantryItemDialogState extends ConsumerState<AddPantryItemDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  String _category = 'Vegetable';
  int _daysUntilExpiry = 7;
  bool _isLoading = false;

  final List<String> _categories = [
    'Vegetable',
    'Fruit',
    'Dairy',
    'Meat',
    'Pantry',
    'Bakery',
    'Snacks',
    'Other',
  ];

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final item = PantryItem(
        id: const Uuid().v4(),
        name: _nameController.text.trim(),
        quantityLabel: '1 unit',
        category: _category,
        imageUrl: '', // No image for manual add specifically
        expiry: DateTime.now().add(Duration(days: _daysUntilExpiry)),
      );

      await ref.read(pantryControllerProvider).addItem(item);

      if (mounted) {
        Navigator.of(context).pop(true);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error adding item: $e')));
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add Item Manually'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Item Name',
                hintText: 'e.g., Tomatoes',
              ),
              textCapitalization: TextCapitalization.sentences,
              validator: (v) =>
                  v?.trim().isEmpty == true ? 'Name required' : null,
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _category,
              decoration: const InputDecoration(labelText: 'Category'),
              items: _categories
                  .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                  .toList(),
              onChanged: (v) => setState(() => _category = v!),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<int>(
              value: _daysUntilExpiry,
              decoration: const InputDecoration(labelText: 'Expires In'),
              items: [1, 2, 3, 5, 7, 14, 30]
                  .map(
                    (d) => DropdownMenuItem(value: d, child: Text('$d days')),
                  )
                  .toList(),
              onChanged: (v) => setState(() => _daysUntilExpiry = v!),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: _isLoading ? null : () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _isLoading ? null : _save,
          child: _isLoading
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Text('Add'),
        ),
      ],
    );
  }
}
