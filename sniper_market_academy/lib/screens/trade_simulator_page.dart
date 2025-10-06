import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/realtime_chart.dart';
import '../providers/trade_provider.dart';
import '../models/trade.dart';

class TradeSimulatorPage extends StatefulWidget {
  const TradeSimulatorPage({super.key});

  @override
  State<TradeSimulatorPage> createState() => _TradeSimulatorPageState();
}

class _TradeSimulatorPageState extends State<TradeSimulatorPage> {
  String _selectedSymbol = "BTCUSDT";
  final List<String> _symbols = ['BTCUSDT', 'ETHUSDT'];

  final TextEditingController entryController = TextEditingController();
  final TextEditingController slController = TextEditingController();
  final TextEditingController tpController = TextEditingController();

  double? _lastPrice;

  /// ✅ Callback quand le prix évolue
  void _updateLastPrice(double price) async {
    final tradeProvider = Provider.of<TradeProvider>(context, listen: false);
    setState(() => _lastPrice = price);

    final activeTrade = tradeProvider.activeTrade;
    if (activeTrade != null) {
      if (_lastPrice! >= activeTrade.tp) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("✅ Trade Gagné 🎉 (TP atteint)")),
        );
        tradeProvider.addToHistory(
          Trade(
            symbol: _selectedSymbol,
            entry: activeTrade.entry,
            sl: activeTrade.sl,
            tp: activeTrade.tp,
            date: DateTime.now(),
            result: 10, // Exemple points
          ),
        );
        tradeProvider.closeTrade(); // ✅ sans argument
      } else if (_lastPrice! <= activeTrade.sl) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("❌ Trade Perdu ❌ (SL touché)")),
        );
        tradeProvider.addToHistory(
          Trade(
            symbol: _selectedSymbol,
            entry: activeTrade.entry,
            sl: activeTrade.sl,
            tp: activeTrade.tp,
            date: DateTime.now(),
            result: -5, // Exemple points
          ),
        );
        tradeProvider.closeTrade(); // ✅ sans argument
      }
    }
  }

  /// ✅ Démarrer un trade
  void _startTrade() {
    final entry = double.tryParse(entryController.text);
    final sl = double.tryParse(slController.text);
    final tp = double.tryParse(tpController.text);

    if (entry == null || sl == null || tp == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("⚠️ Remplis tous les champs.")),
      );
      return;
    }

    final tradeProvider = Provider.of<TradeProvider>(context, listen: false);
    tradeProvider.startTrade(
      Trade(
        symbol: _selectedSymbol,
        entry: entry,
        sl: sl,
        tp: tp,
        date: DateTime.now(),
        result: 0, // résultat calculé plus tard
      ),
    );

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("📌 Trade démarré : Entry $entry | SL $sl | TP $tp"),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final tradeProvider = Provider.of<TradeProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('📈 Simulateur de Trade'),
        backgroundColor: Colors.deepOrange,
      ),
      body: Column(
        children: [
          // 🔽 Barre supérieure : actif + trade actif + historique
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                DropdownButton<String>(
                  value: _selectedSymbol,
                  dropdownColor: Colors.black87,
                  style: const TextStyle(color: Colors.white, fontSize: 16),
                  iconEnabledColor: Colors.deepOrange,
                  onChanged: (String? newValue) {
                    if (newValue != null) {
                      setState(() => _selectedSymbol = newValue);
                    }
                  },
                  items: _symbols.map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),

                // ✅ Bouton Trade en cours
                ElevatedButton(
                  onPressed: () {
                    if (tradeProvider.activeTrade != null) {
                      final t = tradeProvider.activeTrade!;
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            "📌 Trade actif : ${t.symbol} | Entry ${t.entry}, SL ${t.sl}, TP ${t.tp}",
                          ),
                        ),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Aucun trade actif.")),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: tradeProvider.activeTrade != null
                        ? Colors.green
                        : Colors.grey,
                  ),
                  child: Text(tradeProvider.activeTrade != null
                      ? "Trade en cours"
                      : "Aucun trade"),
                ),

                // ✅ Bouton Historique
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/trade_history');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueGrey,
                  ),
                  child: const Text("📜 Historique"),
                ),
              ],
            ),
          ),

          // ✅ Dernier prix affiché
          if (_lastPrice != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Text(
                "Dernier prix : ${_lastPrice!.toStringAsFixed(2)} USDT",
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),

          // 📊 Graphique temps réel
          Expanded(
            flex: 3,
            child: RealtimeChart(
              symbol: _selectedSymbol,
              onPriceUpdate: _updateLastPrice,
              tradeLines: tradeProvider.chartLines,
            ),
          ),

          // ✅ Formulaire
          Expanded(
            flex: 2,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                children: [
                  _buildInputField("Prix d'entrée", entryController),
                  const SizedBox(height: 10),
                  _buildInputField("Stop Loss", slController),
                  const SizedBox(height: 10),
                  _buildInputField("Take Profit", tpController),
                  const SizedBox(height: 20),

                  // ✅ Bouton Démarrer Trade
                  Center(
                    child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _startTrade,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.deepOrange,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 32, vertical: 14),
                        ),
                        child: const Text(
                          "Démarrer Trade",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Champ input formulaire
  Widget _buildInputField(String label, TextEditingController controller) {
    return TextField(
      controller: controller,
      keyboardType: TextInputType.number,
      style: const TextStyle(color: Colors.black),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.black87),
        filled: true,
        fillColor: Colors.white.withOpacity(0.9),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.deepOrange, width: 2),
        ),
      ),
    );
  }
}
