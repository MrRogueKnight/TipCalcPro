import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Custom widget imports
import 'widgets/amount_card.dart';
import 'widgets/bill_input_field.dart';
import 'widgets/tip_presets.dart';
import 'widgets/split_controls.dart';
import 'widgets/history_list.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    final prefs = await SharedPreferences.getInstance();
    runApp(TipCalcPro(prefs: prefs));
  } catch (e) {
    runApp(const ErrorApp());
  }
}

class ErrorApp extends StatelessWidget {
  const ErrorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: Text('Failed to initialize app: Please try again later'),
        ),
      ),
    );
  }
}

class TipCalcPro extends StatelessWidget {
  final SharedPreferences prefs;

  const TipCalcPro({super.key, required this.prefs});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TipCalcPro+',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
          brightness: Brightness.light,
        ),
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
      themeMode: ThemeMode.system,
      home: TipCalculatorScreen(prefs: prefs),
      debugShowCheckedModeBanner: false,
    );
  }
}

class TipCalculatorScreen extends StatefulWidget {
  final SharedPreferences prefs;

  const TipCalculatorScreen({super.key, required this.prefs});

  @override
  State<TipCalculatorScreen> createState() => _TipCalculatorScreenState();
}

class _TipCalculatorScreenState extends State<TipCalculatorScreen>
    with SingleTickerProviderStateMixin {
  double _billAmount = 0.0;
  int _split = 1;
  double _tipPercent = 15.0;
  late AnimationController _animationController;
  late Animation<double> _animation;
  final List<Map<String, dynamic>> _history = [];
  bool _darkMode = false;

  double get _tipAmount => _billAmount * _tipPercent / 100;
  double get _totalAmount => _billAmount + _tipAmount;
  double get _totalPerPerson => _split > 0 ? _totalAmount / _split : _totalAmount;

  final TextEditingController _billController = TextEditingController();
  final FocusNode _billFocusNode = FocusNode();

  final List<double> _tipPresets = [10, 15, 18, 20, 25];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _animation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _loadSettings();
    _billFocusNode.addListener(_handleFocusChange);
  }

  void _handleFocusChange() {
    if (_billFocusNode.hasFocus) {
      _animationController.forward();
    } else {
      _animationController.reverse();
    }
  }

  Future<void> _loadSettings() async {
    try {
      setState(() {
        _darkMode = widget.prefs.getBool('darkMode') ?? false;
      });
    } catch (e) {
      debugPrint('Error loading settings: $e');
    }
  }

  Future<void> _toggleDarkMode() async {
    try {
      await widget.prefs.setBool('darkMode', !_darkMode);
      setState(() {
        _darkMode = !_darkMode;
      });
    } catch (e) {
      debugPrint('Error saving dark mode preference: $e');
    }
  }

  void _addToHistory() {
    if (_billAmount <= 0) return;

    final now = DateTime.now();
    final dateFormat = DateFormat('MMM d, y - h:mm a');

    setState(() {
      _history.insert(0, {
        'date': dateFormat.format(now),
        'billAmount': _billAmount,
        'tipPercent': _tipPercent,
        'split': _split,
        'totalPerPerson': _totalPerPerson,
      });

      if (_history.length > 10) {
        _history.removeLast();
      }
    });
  }

  void _applyHistoryItem(Map<String, dynamic> item) {
    HapticFeedback.lightImpact();
    setState(() {
      _billAmount = (item['billAmount'] as num).toDouble();
      _tipPercent = (item['tipPercent'] as num).toDouble();
      _split = item['split'] as int;
      _billController.text = _billAmount.toStringAsFixed(2);
    });
  }

  void _setTipPercentage(double percent) {
    HapticFeedback.selectionClick();
    setState(() {
      _tipPercent = percent;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'TipCalcPro+',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(_darkMode ? Icons.light_mode : Icons.dark_mode),
            onPressed: _toggleDarkMode,
            tooltip: 'Toggle dark mode',
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AmountCard(
              totalPerPerson: _totalPerPerson,
              totalAmount: _totalAmount,
              tipAmount: _tipAmount,
              animation: _animation,
            ),
            const SizedBox(height: 20),
            BillInputField(
              controller: _billController,
              focusNode: _billFocusNode,
              onChanged: (value) {
                final parsedValue = double.tryParse(value) ?? 0.0;
                if (parsedValue >= 0) {
                  setState(() {
                    _billAmount = parsedValue;
                  });
                }
              },
            ),
            const SizedBox(height: 20),
            const Text('Tip Percentage', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            TipPresets(
              presets: _tipPresets,
              selected: _tipPercent,
              onSelected: _setTipPercentage,
            ),
            const SizedBox(height: 20),
            const Text('Split Between', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            SplitControls(
              split: _split,
              onIncrement: () => setState(() => _split++),
              onDecrement: () => setState(() => _split = _split > 1 ? _split - 1 : 1),
            ),
            HistoryList(history: _history, onItemTap: _applyHistoryItem),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addToHistory,
        tooltip: 'Save to history',
        child: const Icon(Icons.save),
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    _billController.dispose();
    _billFocusNode.removeListener(_handleFocusChange);
    _billFocusNode.dispose();
    super.dispose();
  }
}
