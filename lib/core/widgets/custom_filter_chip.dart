import 'package:flutter/material.dart';
import 'package:greeting_app/core/theme/tet_colors.dart';

class CustomFilterChip extends StatelessWidget {
  final String label;
  final bool selected;
  final Function(bool) onSelected;

  const CustomFilterChip({
    super.key,
    required this.label,
    required this.selected,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return FilterChip(
      label: Text(label),
      selected: selected,
      onSelected: onSelected,
      selectedColor: TetColors.luckyRed.withOpacity(0.12),
      checkmarkColor: TetColors.luckyRed,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    );
  }
}
