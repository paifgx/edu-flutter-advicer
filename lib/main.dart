import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Advicer',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
        textTheme: const TextTheme(
          headlineMedium: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      home: const AdvicePage(),
    );
  }
}

class AdvicePage extends StatefulWidget {
  const AdvicePage({super.key});

  @override
  State<AdvicePage> createState() => _AdvicePageState();
}

class _AdvicePageState extends State<AdvicePage> {
  String _advice = '"Your Advice here"';
  bool _isLoading = false;
  String? _error;

  Future<void> _getAdvice() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final result = await _fakeFetchAdvice();
      setState(() {
        _advice = '"$result"';
      });
    } catch (e) {
      setState(() {
        _error = 'Konnte keinen Ratschlag laden.';
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<String> _fakeFetchAdvice() async {
    // Simuliert Netzwerk: 1.2s warten
    await Future.delayed(const Duration(milliseconds: 1200));

    // 20% Fehlerrate, um Fehleranzeige zu demonstrieren
    final millis = DateTime.now().millisecond;
    if (millis % 5 == 0) {
      throw Exception('Network error');
    }

    const advices = [
      "Don't eat yellow snow.",
      "Never trust a computer you can't throw out a window.",
      "Simplicity is the ultimate sophistication.",
      "Measure twice, cut once.",
      "If in doubt, log it out."
    ];
    return advices[millis % advices.length];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Advicer'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Spacer(),
              if (_isLoading) ...[
                const CircularProgressIndicator(),
                const SizedBox(height: 24),
              ],
              Text(
                _advice,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 24),
              if (_error != null)
                Text(
                  _error!,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.red),
                )
              else
                const Text(
                  'Hier wird später ein echter Ratschlag von der API stehen.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey),
                ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _getAdvice,
                  child: const Padding(
                    padding: EdgeInsets.symmetric(vertical: 14.0),
                    child: Text(
                      'GET ADVICE',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}
