import 'package:flutter/material.dart';

class AmountCard extends StatelessWidget {
  final double totalPerPerson;
  final double totalAmount;
  final double tipAmount;
  final Animation<double> animation;

  const AmountCard({
    super.key,
    required this.totalPerPerson,
    required this.totalAmount,
    required this.tipAmount,
    required this.animation,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return ScaleTransition(
      scale: animation,
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: LinearGradient(
              colors: [
                Color.lerp(colorScheme.primary, colorScheme.surface, 0.2)!,
                colorScheme.primary,
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              const Text('Total Per Person', style: TextStyle(fontSize: 18, color: Colors.white)),
              const SizedBox(height: 8),
              Text(
                '\$${totalPerPerson.toStringAsFixed(2)}',
                style: const TextStyle(fontSize: 36, fontWeight: FontWeight.bold, color: Colors.white),
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _InfoColumn(label: 'Total Bill', value: totalAmount),  // USING _InfoColumn
                  _InfoColumn(label: 'Tip Amount', value: tipAmount),   // USING _InfoColumn
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Helper widget - only exists if used in this file
class _InfoColumn extends StatelessWidget {
  final String label;
  final double value;

  const _InfoColumn({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(label, style: const TextStyle(fontSize: 14, color: Colors.white70)),
        Text(
          '\$${value.toStringAsFixed(2)}',
          style: const TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}