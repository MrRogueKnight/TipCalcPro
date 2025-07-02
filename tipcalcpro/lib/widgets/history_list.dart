import 'package:flutter/material.dart';

class HistoryList extends StatelessWidget {
  final List<Map<String, dynamic>> history;
  final void Function(Map<String, dynamic>) onItemTap;

  const HistoryList({
    super.key,
    required this.history,
    required this.onItemTap,
  });

  @override
  Widget build(BuildContext context) {
    if (history.isEmpty) return const SizedBox();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        const Text(
          'History',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: history.length,
          separatorBuilder: (_, __) => const Divider(),
          itemBuilder: (context, index) {
            final item = history[index];
            return ListTile(
              title: Text(
                '\$${item['billAmount'].toStringAsFixed(2)} — ${item['tipPercent']}% Tip',
              ),
              subtitle: Text(item['date']),
              trailing: Text('Split: ${item['split']}'),
              onTap: () => onItemTap(item),
            );
          },
        ),
      ],
    );
  }
}
