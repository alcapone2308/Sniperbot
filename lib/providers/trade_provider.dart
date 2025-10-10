import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/trade.dart';

class TradeProvider extends ChangeNotifier {
  static const _boxName = 'trades_data';

  final List<Trade> _openTrades = [];
  final List<Trade> _closedTrades = [];

  /// ✅ Expose les listes
  List<Trade> get openTrades => List.unmodifiable(_openTrades);
  List<Trade> get closedTrades => List.unmodifiable(_closedTrades);

  /// ✅ Getter combiné utilisé par le simulateur (corrige ton erreur)
  List<Trade> get trades => [
    ..._openTrades,
    ..._closedTrades,
  ];

  /// ✅ Chargement depuis Hive
  Future<void> loadTrade() async {
    final box = Hive.box(_boxName);

    final open = List<Map<String, dynamic>>.from(
        box.get('open', defaultValue: []) as List);
    final closed = List<Map<String, dynamic>>.from(
        box.get('closed', defaultValue: []) as List);

    _openTrades
      ..clear()
      ..addAll(open.map((m) => Trade.fromMap(m)));
    _closedTrades
      ..clear()
      ..addAll(closed.map((m) => Trade.fromMap(m)));

    notifyListeners();
  }

  /// ✅ Sauvegarde Hive
  Future<void> _persist() async {
    final box = Hive.box(_boxName);
    await box.put('open', _openTrades.map((t) => t.toMap()).toList());
    await box.put('closed', _closedTrades.map((t) => t.toMap()).toList());
  }

  /// ✅ Ouvrir un nouveau trade
  Trade openTrade({
    required String symbol,
    required TradeSide side,
    required double qty,
    required double entryPrice,
    double? sl,
    double? tp,
  }) {
    final trade = Trade(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      symbol: symbol.toUpperCase(),
      side: side,
      qty: qty,
      entryPrice: entryPrice,
      sl: sl,
      tp: tp,
      openedAt: DateTime.now(),
    );

    _openTrades.insert(0, trade);
    _persist();
    notifyListeners();
    return trade;
  }

  /// ✅ Clôturer un trade (manuellement ou auto TP/SL)
  Trade? closeTrade({
    required String tradeId,
    required double closePrice,
    required String reason, // "manual" | "hit_tp" | "hit_sl"
  }) {
    final idx = _openTrades.indexWhere((t) => t.id == tradeId);
    if (idx == -1) return null;

    final t = _openTrades.removeAt(idx);
    final priceDiff = (t.side == TradeSide.buy)
        ? (closePrice - t.entryPrice)
        : (t.entryPrice - closePrice);
    final pnl = priceDiff * t.qty;

    final closed = t.copyWith(
      closedAt: DateTime.now(),
      closePrice: closePrice,
      pnl: pnl,
      status: "closed",
      closeReason: reason,
    );

    _closedTrades.insert(0, closed);
    _persist();
    notifyListeners();
    return closed;
  }

  /// ✅ Vérifie si une position doit être fermée automatiquement (TP/SL)
  List<Trade> checkAutoClose({
    required String symbol,
    required double currentPrice,
  }) {
    final closedNow = <Trade>[];
    final toClose = <Trade>[];

    for (final t in _openTrades.where((t) => t.symbol == symbol.toUpperCase())) {
      bool shouldClose = false;

      if (t.tp != null) {
        if (t.side == TradeSide.buy && currentPrice >= t.tp!) {
          shouldClose = true;
        } else if (t.side == TradeSide.sell && currentPrice <= t.tp!) {
          shouldClose = true;
        }
      }
      if (!shouldClose && t.sl != null) {
        if (t.side == TradeSide.buy && currentPrice <= t.sl!) {
          shouldClose = true;
        } else if (t.side == TradeSide.sell && currentPrice >= t.sl!) {
          shouldClose = true;
        }
      }

      if (shouldClose) {
        final reason = (t.tp != null &&
            ((t.side == TradeSide.buy && currentPrice >= t.tp!) ||
                (t.side == TradeSide.sell && currentPrice <= t.tp!)))
            ? "hit_tp"
            : "hit_sl";

        final c = closeTrade(
          tradeId: t.id,
          closePrice: currentPrice,
          reason: reason,
        );
        if (c != null) closedNow.add(c);
      }
    }

    return closedNow;
  }

  /// ✅ Supprime toutes les données (utile pour debug ou reset)
  Future<void> clearAll() async {
    _openTrades.clear();
    _closedTrades.clear();
    await _persist();
    notifyListeners();
  }
}
