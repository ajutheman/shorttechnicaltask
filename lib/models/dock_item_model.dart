import 'package:flutter/material.dart';

/// Model class for dock items.
class DockItemModel {
  const DockItemModel({
    required this.icon,
    required this.label,
  });

  /// Icon to display for the item.
  final IconData icon;

  /// Label to display for the item.
  final String label;
}
