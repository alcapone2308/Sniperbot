import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/trade.dart';

class WalletProvider extends ChangeNotifier {
  static const _boxName = 'wallet_data';

  double _balance = 10000; // solde initial fictif
  double _realizedPnL = 0;
  double _bestTrade = 0;
  double _worstTrade = 0;

  double get balance => _balance;
  double get realizedPnL => _realizedPnL;
  double get bestTrade => _bestTrade;
  double get worstTrade => _worstTrade;

  Future<void> load() async {
    final b = Hive.box(_boxName);
    _balance = (b.get('balance', defaultValue: 10000) as num).toDouble();
    _realizedPnL = (b.get('realizedPnL', defaultValue: 0) as num).toDouble();
    _bestTrade = (b.get('bestTrade', defaultValue: 0) as num).toDouble();
    _worstTrade = (b.get('worstTrade', defaultValue: 0) as num).toDouble();
    notifyListeners();
  }

  Future<void> _persist() async {
    final b = Hive.box(_boxName);
    await b.put('balance', _balance);
    await b.put('realizedPnL', _realizedPnL);
    await b.put('bestTrade', _bestTrade);
    await b.put('worstTrade', _worstTrade);
  }

  // à appeler quand un trade est clôturé
  Future<void> applyClosedTrade(Trade t) async {
    final pnl = t.pnl ?? 0;
    _realizedPnL += pnl;
    _balance += pnl;
    if (pnl > _bestTrade) _bestTrade = pnl;
    if (pnl < _worstTrade) _worstTrade = pnl;
    await _persist();
    notifyListeners();
  }
}
