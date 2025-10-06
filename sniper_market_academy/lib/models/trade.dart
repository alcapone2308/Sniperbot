class Trade {
  final String symbol;
  final double entry;
  final double sl;
  final double tp;
  final DateTime date;
  int result; // ✅ Score ou PnL (0 = neutre)

  Trade({
    required this.symbol,
    required this.entry,
    required this.sl,
    required this.tp,
    DateTime? date,
    this.result = 0,
  }) : date = date ?? DateTime.now();

  Map<String, dynamic> toMap() {
    return {
      'symbol': symbol,
      'entry': entry,
      'sl': sl,
      'tp': tp,
      'date': date.toIso8601String(),
      'result': result,
    };
  }

  factory Trade.fromMap(Map<String, dynamic> map) {
    return Trade(
      symbol: map['symbol'] ?? '',
      entry: (map['entry'] ?? 0).toDouble(),
      sl: (map['sl'] ?? 0).toDouble(),
      tp: (map['tp'] ?? 0).toDouble(),
      date: DateTime.tryParse(map['date'] ?? '') ?? DateTime.now(),
      result: map['result'] ?? 0,
    );
  }
}
