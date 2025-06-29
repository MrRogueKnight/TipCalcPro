import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const TipCalcPro());
}

class TipCalcPro extends StatelessWidget {
  const TipCalcPro({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TipCalcPro',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const TipCalculatorScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class TipCalculatorScreen extends StatefulWidget {
  const TipCalculatorScreen({super.key});

  @override
  State<TipCalculatorScreen> createState() => _TipCalculatorScreenState();
}

class _TipCalculatorScreenState extends State<TipCalculatorScreen> {
  double _billAmount = 0.0;
  int _split = 1;
  double _tipPercent = 15.0;

  double get _tipAmount => _billAmount * _tipPercent / 100;
  double get _totalPerPerson => (_billAmount + _tipAmount) / _split;

  final TextEditingController _billController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('TipCalcPro'), centerTitle: true),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Total per person
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              color: Colors.deepPurple[100],
              child: SizedBox(
                width: double.infinity,
                height: 100,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Total Per Person',
                        style: TextStyle(fontSize: 16),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '\$${_totalPerPerson.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Bill amount input
            TextField(
              controller: _billController,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              decoration: const InputDecoration(
                prefixText: '\$ ',
                labelText: 'Bill Amount',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                setState(() {
                  _billAmount = double.tryParse(value) ?? 0.0;
                });
              },
            ),
            const SizedBox(height: 24),

            // Split Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Split', style: TextStyle(fontSize: 16)),
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.remove_circle_outline),
                      onPressed: () {
                        setState(() {
                          if (_split > 1) _split--;
                        });
                      },
                    ),
                    Text('$_split', style: const TextStyle(fontSize: 18)),
                    IconButton(
                      icon: const Icon(Icons.add_circle_outline),
                      onPressed: () {
                        setState(() {
                          _split++;
                        });
                      },
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Tip Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Text('Tip: ', style: TextStyle(fontSize: 16)),
                    Text(
                      '${_tipPercent.toStringAsFixed(1)}%',
                      style: const TextStyle(fontSize: 16),
                    ),
                  ],
                ),
                Text(
                  '\$${_tipAmount.toStringAsFixed(2)}',
                  style: const TextStyle(fontSize: 16),
                ),
              ],
            ),
            const SizedBox(height: 8),

            // Tip slider
            Slider(
              min: 0,
              max: 100,
              divisions: 100,
              value: _tipPercent,
              label: '${_tipPercent.toStringAsFixed(1)}%',
              onChanged: (value) {
                setState(() {
                  _tipPercent = value;
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}
