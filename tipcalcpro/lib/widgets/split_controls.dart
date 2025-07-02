import 'package:flutter/material.dart';

class SplitControls extends StatelessWidget {
  final int split;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;

  const SplitControls({
    super.key,
    required this.split,
    required this.onIncrement,
    required this.onDecrement,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          icon: const Icon(Icons.remove),
          onPressed: split > 1 ? onDecrement : null,
        ),
        Text(
          '$split',
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        IconButton(icon: const Icon(Icons.add), onPressed: onIncrement),
      ],
    );
  }
}
