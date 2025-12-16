import 'package:flutter/material.dart';

enum PantryStatus { fresh, warning, urgent, expired }

class PantryItem {
  final String id;
  final String name;
  final String quantityLabel;
  final String category;
  final DateTime? expiry;
  final String imageUrl;

  const PantryItem({
    required this.id,
    required this.name,
    required this.quantityLabel,
    required this.category,
    required this.imageUrl,
    this.expiry,
  });

  PantryStatus get status {
    if (expiry == null) return PantryStatus.fresh;
    final diff = expiry!.difference(DateTime.now()).inDays;
    if (diff < 0) return PantryStatus.expired;
    if (diff == 0) return PantryStatus.urgent;
    if (diff <= 3) return PantryStatus.warning;
    return PantryStatus.fresh;
  }

  Color statusColor(BuildContext context) {
    switch (status) {
      case PantryStatus.fresh:
        return Colors.green;
      case PantryStatus.warning:
        return Colors.amber;
      case PantryStatus.urgent:
        return Colors.redAccent;
      case PantryStatus.expired:
        return Colors.red;
    }
  }
}

