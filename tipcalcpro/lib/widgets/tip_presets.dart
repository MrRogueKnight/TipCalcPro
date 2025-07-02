import 'package:flutter/material.dart';

class TipPresets extends StatelessWidget {
  final List<double> presets;
  final double selected;
  final void Function(double) onSelected;

  const TipPresets({
    super.key,
    required this.presets,
    required this.selected,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      children: presets.map((percent) {
        final isSelected = percent == selected;
        return ChoiceChip(
          label: Text('${percent.toInt()}%'),
          selected: isSelected,
          onSelected: (_) => onSelected(percent),
          selectedColor: Theme.of(context).colorScheme.primary,
          labelStyle: TextStyle(
            color: isSelected ? Colors.white : null,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        );
      }).toList(),
    );
  }
}
