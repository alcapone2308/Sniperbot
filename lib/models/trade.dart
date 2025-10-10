import 'package:flutter/foundation.dart';

enum TradeSide { buy, sell }

class Trade {
  final String id;
  final String symbol;
  final TradeSide side;
  final double qty;
  final double entryPrice;
  final double? sl;
  final double? tp;
  final DateTime openedAt;

  // Champs de fermeture
  final DateTime? closedAt;
  final double? closePrice;
  final double? pnl; // qty * (close - entry)
  final String status; // "open" | "closed"
  final String? closeReason; // "manual" | "hit_tp" | "hit_sl"

  const Trade({
    required this.id,
    required this.symbol,
    required this.side,
    required this.qty,
    required this.entryPrice,
    required this.openedAt,
    this.sl,
    this.tp,
    this.closedAt,
    this.closePrice,
    this.pnl,
    this.status = "open",
    this.closeReason,
  });

  /// ✅ Getter utile pour filtrer les positions ouvertes
  bool get isOpen => status == "open" && closePrice == null;

  /// ✅ Getter pratique pour le calcul du PnL en cours
  double get unrealizedPnl {
    if (closePrice != null) return 0;
    return 0.0;
  }

  Trade copyWith({
    String? id,
    String? symbol,
    TradeSide? side,
    double? qty,
    double? entryPrice,
    double? sl,
    double? tp,
    DateTime? openedAt,
    DateTime? closedAt,
    double? closePrice,
    double? pnl,
    String? status,
    String? closeReason,
  }) {
    return Trade(
      id: id ?? this.id,
      symbol: symbol ?? this.symbol,
      side: side ?? this.side,
      qty: qty ?? this.qty,
      entryPrice: entryPrice ?? this.entryPrice,
      sl: sl ?? this.sl,
      tp: tp ?? this.tp,
      openedAt: openedAt ?? this.openedAt,
      closedAt: closedAt ?? this.closedAt,
      closePrice: closePrice ?? this.closePrice,
      pnl: pnl ?? this.pnl,
      status: status ?? this.status,
      closeReason: closeReason ?? this.closeReason,
    );
  }

  Map<String, dynamic> toMap() => {
    'id': id,
    'symbol': symbol,
    'side': describeEnum(side),
    'qty': qty,
    'entryPrice': entryPrice,
    'sl': sl,
    'tp': tp,
    'openedAt': openedAt.toIso8601String(),
    'closedAt': closedAt?.toIso8601String(),
    'closePrice': closePrice,
    'pnl': pnl,
    'status': status,
    'closeReason': closeReason,
  };

  factory Trade.fromMap(Map<String, dynamic> m) {
    return Trade(
      id: m['id'] as String,
      symbol: (m['symbol'] as String).toUpperCase(),
      side: (m['side'] == 'buy') ? TradeSide.buy : TradeSide.sell,
      qty: (m['qty'] as num).toDouble(),
      entryPrice: (m['entryPrice'] as num).toDouble(),
      sl: (m['sl'] == null) ? null : (m['sl'] as num).toDouble(),
      tp: (m['tp'] == null) ? null : (m['tp'] as num).toDouble(),
      openedAt: DateTime.parse(m['openedAt'] as String),
      closedAt:
      (m['closedAt'] == null) ? null : DateTime.parse(m['closedAt']),
      closePrice: (m['closePrice'] == null)
          ? null
          : (m['closePrice'] as num).toDouble(),
      pnl: (m['pnl'] == null) ? null : (m['pnl'] as num).toDouble(),
      status: (m['status'] as String?) ?? "open",
      closeReason: m['closeReason'] as String?,
    );
  }
}
