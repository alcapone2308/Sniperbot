import 'package:flutter/material.dart';
import '../widgets/realtime_chart.dart';

class SimulatorPage extends StatefulWidget {
  const SimulatorPage({super.key});

  @override
  State<SimulatorPage> createState() => _SimulatorPageState();
}

class _SimulatorPageState extends State<SimulatorPage> {
  String _selectedSymbol = 'BTCUSDT'; // Actif par défaut

  final List<String> _symbols = [
    'BTCUSDT',
    'ETHUSDT',
    'BNBUSDT',
    'SOLUSDT',
    'XRPUSDT',
    'DOGEUSDT',
    'ADAUSDT',
    'AVAXUSDT',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("📊 Simulateur de Trade"),
        backgroundColor: Colors.deepOrange,
      ),
      body: Column(
        children: [
          const SizedBox(height: 8),
          DropdownButton<String>(
            value: _selectedSymbol,
            onChanged: (value) {
              if (value != null) {
                setState(() => _selectedSymbol = value);
              }
            },
            items: _symbols.map((symbol) {
              return DropdownMenuItem(
                value: symbol,
                child: Text(symbol),
              );
            }).toList(),
          ),
          Expanded(
            child: RealtimeChart(symbol: _selectedSymbol),
          ),
        ],
      ),
    );
  }
}
