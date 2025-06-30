import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  runApp(TipCalcPro(prefs: prefs));
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
  double get _totalPerPerson => _totalAmount / _split;

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
    _billFocusNode.addListener(() {
      if (_billFocusNode.hasFocus) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
    });
  }

  Future<void> _loadSettings() async {
    setState(() {
      _darkMode = widget.prefs.getBool('darkMode') ?? false;
    });
  }

  Future<void> _toggleDarkMode() async {
    setState(() {
      _darkMode = !_darkMode;
    });
    await widget.prefs.setBool('darkMode', _darkMode);
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
      _billAmount = item['billAmount'];
      _tipPercent = item['tipPercent'];
      _split = item['split'];
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
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('TipCalcPro+', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(_darkMode ? Icons.light_mode : Icons.dark_mode),
            onPressed: _toggleDarkMode,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            ScaleTransition(
              scale: _animation,
              child: Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    gradient: LinearGradient(
                      colors: [
                        colorScheme.primary.withValues(alpha: (0.8 * 255).round()),
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
                        '\$${_totalPerPerson.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontSize: 36,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Column(
                            children: [
                              const Text('Total Bill', style: TextStyle(fontSize: 14, color: Colors.white70)),
                              Text(
                                '\$${_totalAmount.toStringAsFixed(2)}',
                                style: const TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          Column(
                            children: [
                              const Text('Tip Amount', style: TextStyle(fontSize: 14, color: Colors.white70)),
                              Text(
                                '\$${_tipAmount.toStringAsFixed(2)}',
                                style: const TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            // ... remaining UI code continues unchanged ...
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addToHistory,
        child: const Icon(Icons.save),
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    _billController.dispose();
    _billFocusNode.dispose();
    super.dispose();
  }
}
