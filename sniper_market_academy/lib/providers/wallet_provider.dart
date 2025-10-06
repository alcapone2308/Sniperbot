import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';

class WalletProvider with ChangeNotifier {
  late Box _walletBox;
  
  double _balance = 10000.0;
  double _totalProfit = 0.0;
  double _bestTrade = 0.0;
  int _tradesCount = 0;
  List<Map<String, dynamic>> _transactions = [];
  List<Map<String, dynamic>> _positions = [];

  // Getters
  double get balance => _balance;
  double get totalProfit => _totalProfit;
  double get bestTrade => _bestTrade;
  int get tradesCount => _tradesCount;
  List<Map<String, dynamic>> get transactions => _transactions;
  List<Map<String, dynamic>> get positions => _positions;
  
  double get totalPortfolioValue {
    double positionsValue = 0.0;
    for (var position in _positions) {
      positionsValue += position['currentValue'] ?? 0.0;
    }
    return _balance + positionsValue;
  }

  Future<void> loadWallet() async {
    _walletBox = Hive.box('wallet_data');
    _balance = _walletBox.get('balance', defaultValue: 10000.0);
    _totalProfit = _walletBox.get('total_profit', defaultValue: 0.0);
    _bestTrade = _walletBox.get('best_trade', defaultValue: 0.0);
    _tradesCount = _walletBox.get('trades_count', defaultValue: 0);
    
    // Charger les transactions
    final transactionsData = _walletBox.get('transactions', defaultValue: []);
    _transactions = List<Map<String, dynamic>>.from(transactionsData);
    
    // Charger les positions
    final positionsData = _walletBox.get('positions', defaultValue: []);
    _positions = List<Map<String, dynamic>>.from(positionsData);
    
    notifyListeners();
  }

  Future<void> _saveWallet() async {
    await _walletBox.put('balance', _balance);
    await _walletBox.put('total_profit', _totalProfit);
    await _walletBox.put('best_trade', _bestTrade);
    await _walletBox.put('trades_count', _tradesCount);
    await _walletBox.put('transactions', _transactions);
    await _walletBox.put('positions', _positions);
  }

  /// Exécuter un achat
  Future<bool> executeBuy({
    required String symbol,
    required double price,
    required double quantity,
  }) async {
    final cost = price * quantity;
    
    if (cost > _balance) {
      return false; // Solde insuffisant
    }
    
    // Déduire du solde
    _balance -= cost;
    
    // Ajouter ou mettre à jour la position
    final existingPositionIndex = _positions.indexWhere(
      (p) => p['symbol'] == symbol,
    );
    
    if (existingPositionIndex != -1) {
      // Mettre à jour position existante
      final existingPosition = _positions[existingPositionIndex];
      final totalQuantity = existingPosition['quantity'] + quantity;
      final avgPrice = ((existingPosition['quantity'] * existingPosition['buyPrice']) + cost) / totalQuantity;
      
      _positions[existingPositionIndex] = {
        'symbol': symbol,
        'quantity': totalQuantity,
        'buyPrice': avgPrice,
        'currentPrice': price,
        'currentValue': totalQuantity * price,
        'profitLoss': (price - avgPrice) * totalQuantity,
        'profitLossPercent': ((price - avgPrice) / avgPrice) * 100,
      };
    } else {
      // Nouvelle position
      _positions.add({
        'symbol': symbol,
        'quantity': quantity,
        'buyPrice': price,
        'currentPrice': price,
        'currentValue': cost,
        'profitLoss': 0.0,
        'profitLossPercent': 0.0,
      });
    }
    
    // Ajouter la transaction
    _transactions.insert(0, {
      'type': 'buy',
      'symbol': symbol,
      'price': price,
      'quantity': quantity,
      'total': cost,
      'date': DateTime.now().toIso8601String(),
    });
    
    _tradesCount++;
    
    await _saveWallet();
    notifyListeners();
    return true;
  }

  /// Exécuter une vente
  Future<bool> executeSell({
    required String symbol,
    required double price,
    required double quantity,
  }) async {
    final positionIndex = _positions.indexWhere(
      (p) => p['symbol'] == symbol,
    );
    
    if (positionIndex == -1) {
      return false; // Position introuvable
    }
    
    final position = _positions[positionIndex];
    
    if (position['quantity'] < quantity) {
      return false; // Quantité insuffisante
    }
    
    final proceeds = price * quantity;
    final profit = (price - position['buyPrice']) * quantity;
    
    // Ajouter au solde
    _balance += proceeds;
    _totalProfit += profit;
    
    // Mettre à jour le meilleur trade
    if (profit > _bestTrade) {
      _bestTrade = profit;
    }
    
    // Mettre à jour ou supprimer la position
    if (position['quantity'] == quantity) {
      _positions.removeAt(positionIndex);
    } else {
      final remainingQuantity = position['quantity'] - quantity;
      _positions[positionIndex] = {
        'symbol': symbol,
        'quantity': remainingQuantity,
        'buyPrice': position['buyPrice'],
        'currentPrice': price,
        'currentValue': remainingQuantity * price,
        'profitLoss': (price - position['buyPrice']) * remainingQuantity,
        'profitLossPercent': ((price - position['buyPrice']) / position['buyPrice']) * 100,
      };
    }
    
    // Ajouter la transaction
    _transactions.insert(0, {
      'type': 'sell',
      'symbol': symbol,
      'price': price,
      'quantity': quantity,
      'total': proceeds,
      'profit': profit,
      'date': DateTime.now().toIso8601String(),
    });
    
    _tradesCount++;
    
    await _saveWallet();
    notifyListeners();
    return true;
  }

  /// Mettre à jour les prix actuels des positions
  Future<void> updatePositionPrices(Map<String, double> prices) async {
    for (var i = 0; i < _positions.length; i++) {
      final symbol = _positions[i]['symbol'];
      if (prices.containsKey(symbol)) {
        final currentPrice = prices[symbol]!;
        final buyPrice = _positions[i]['buyPrice'];
        final quantity = _positions[i]['quantity'];
        
        _positions[i]['currentPrice'] = currentPrice;
        _positions[i]['currentValue'] = currentPrice * quantity;
        _positions[i]['profitLoss'] = (currentPrice - buyPrice) * quantity;
        _positions[i]['profitLossPercent'] = ((currentPrice - buyPrice) / buyPrice) * 100;
      }
    }
    
    await _saveWallet();
    notifyListeners();
  }

  /// Réinitialiser le portefeuille
  Future<void> resetWallet() async {
    _balance = 10000.0;
    _totalProfit = 0.0;
    _bestTrade = 0.0;
    _tradesCount = 0;
    _transactions = [];
    _positions = [];
    
    await _saveWallet();
    notifyListeners();
  }
}
