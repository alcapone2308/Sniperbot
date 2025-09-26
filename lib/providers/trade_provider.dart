import 'package:flutter/foundation.dart';
import '../models/trade.dart';
import '../widgets/realtime_chart.dart'; // ✅ importer TradeLine & TradeLineType

class TradeProvider extends ChangeNotifier {
  Trade? activeTrade;
  final List<Trade> history = [];
  final List<TradeLine> _chartLines = [];

  List<TradeLine> get chartLines => _chartLines;

  /// 🚀 Démarrer un trade
  void startTrade(Trade trade) {
    activeTrade = trade;
    _chartLines.clear();

    _chartLines.addAll([
      TradeLine(type: TradeLineType.entry, price: trade.entry),
      TradeLine(type: TradeLineType.sl, price: trade.sl),
      TradeLine(type: TradeLineType.tp, price: trade.tp),
    ]);

    notifyListeners();
  }

  /// 🚀 Fermer un trade
  void closeTrade() {
    activeTrade = null;
    _chartLines.clear();
    notifyListeners();
  }

  /// 🚀 Ajouter au journal
  void addToHistory(Trade trade) {
    history.add(trade);
    notifyListeners();
  }

  /// 🚀 Charger les trades sauvegardés (placeholder)
  Future<void> loadTrade() async {
    // Ici tu pourras recharger depuis Firebase ou SharedPreferences
    return;
  }
}
