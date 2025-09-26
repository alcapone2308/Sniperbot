import 'package:flutter/material.dart';
import 'package:candlesticks/candlesticks.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'dart:math';

// ✅ Déclarations globales
enum TradeLineType { entry, sl, tp }

class TradeLine {
  TradeLineType type;
  double price;
  TradeLine({required this.type, required this.price});
}

class RealtimeChart extends StatefulWidget {
  final String symbol; // ex: "BTCUSDT"
  final Function(double)? onPriceUpdate; // callback prix
  final List<TradeLine>? tradeLines; // lignes envoyées par la page
  // ✅ Paddings pour aligner l’overlay sur la zone prix (sans header/volumes)
  final double chartTopPadding;
  final double chartBottomPadding;

  const RealtimeChart({
    Key? key,
    required this.symbol,
    this.onPriceUpdate,
    this.tradeLines,
    this.chartTopPadding = 32,   // ≈ barre intervalle
    this.chartBottomPadding = 96, // ≈ volumes + axe X
  }) : super(key: key);

  @override
  State<RealtimeChart> createState() => _RealtimeChartState();
}

class _RealtimeChartState extends State<RealtimeChart> {
  List<Candle> _candles = [];
  Timer? _timer;
  double? _currentPrice;
  String interval = "1m";
  final int limit = 200;

  // ✅ Lignes ajoutées via long press (en plus de widget.tradeLines)
  List<TradeLine> _tradeLines = [];

  @override
  void initState() {
    super.initState();
    _fetchCandles();
    _timer = Timer.periodic(const Duration(seconds: 5), (_) => _fetchCandles());
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Future<void> _fetchCandles() async {
    try {
      final url = Uri.parse(
        "https://api.binance.com/api/v3/klines?symbol=${widget.symbol}&interval=$interval&limit=$limit",
      );

      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = json.decode(response.body) as List;

        final parsed = data.map((e) {
          return Candle(
            date: DateTime.fromMillisecondsSinceEpoch(e[0]),
            open: double.parse(e[1]),
            high: double.parse(e[2]),
            low: double.parse(e[3]),
            close: double.parse(e[4]),
            volume: double.parse(e[5]),
          );
        }).toList();

        setState(() {
          _candles = parsed;
          _currentPrice = _candles.isNotEmpty ? _candles.last.close : null;
        });

        if (_candles.isNotEmpty && widget.onPriceUpdate != null) {
          widget.onPriceUpdate!(_candles.last.close);
        }
      } else {
        debugPrint("Erreur Binance: ${response.body}");
      }
    } catch (e) {
      debugPrint("Erreur chargement bougies: $e");
    }
  }

  // ---- Helpers prix <-> Y (sur la zone UTILISABLE uniquement) ----
  double _priceToY(double price, double height) {
    if (_candles.isEmpty) return height / 2;
    final minP = _candles.map((c) => c.low).reduce(min);
    final maxP = _candles.map((c) => c.high).reduce(max);
    if (maxP == minP) return height / 2;
    // Y = 0 en haut de la zone utilisable
    return (maxP - price) / (maxP - minP) * height;
  }

  double _yToPrice(double y, double height) {
    if (_candles.isEmpty) return 0;
    final minP = _candles.map((c) => c.low).reduce(min);
    final maxP = _candles.map((c) => c.high).reduce(max);
    final ratio = (y / height).clamp(0.0, 1.0);
    return maxP - ratio * (maxP - minP);
  }

  @override
  Widget build(BuildContext context) {
    if (_candles.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    // ✅ Fusion lignes locales + lignes de la page (Entry/SL/TP)
    final List<TradeLine> allLines = [
      ..._tradeLines,
      ...(widget.tradeLines ?? []),
    ];

    return Stack(
      children: [
        Candlesticks(
          candles: _candles,
          interval: interval,
          onIntervalChange: (newInterval) {
            setState(() => interval = newInterval);
            _fetchCandles();
            return Future.value();
          },
        ),

        // ✅ Overlay CALÉ sur la zone prix (padding top/bottom)
        Positioned.fill(
          child: Padding(
            padding: EdgeInsets.only(
              top: widget.chartTopPadding,
              bottom: widget.chartBottomPadding,
            ),
            child: LayoutBuilder(
              builder: (context, constraints) {
                final usableHeight = constraints.maxHeight;

                return GestureDetector(
                  // Long press = cycle Entry -> SL -> TP -> Entry...
                  onLongPressStart: (details) {
                    final price = _yToPrice(details.localPosition.dy, usableHeight);

                    TradeLineType type;
                    final hasEntry = _tradeLines.any((l) => l.type == TradeLineType.entry);
                    final hasSL = _tradeLines.any((l) => l.type == TradeLineType.sl);
                    final hasTP = _tradeLines.any((l) => l.type == TradeLineType.tp);

                    if (!hasEntry) type = TradeLineType.entry;
                    else if (!hasSL) type = TradeLineType.sl;
                    else if (!hasTP) type = TradeLineType.tp;
                    else type = TradeLineType.entry;

                    setState(() {
                      _tradeLines.removeWhere((l) => l.type == type);
                      _tradeLines.add(TradeLine(type: type, price: price));
                    });
                  },
                  // Double tap près d'une ligne -> supprimer
                  onDoubleTapDown: (details) {
                    final dy = details.localPosition.dy;
                    for (int i = 0; i < _tradeLines.length; i++) {
                      final y = _priceToY(_tradeLines[i].price, usableHeight);
                      if ((y - dy).abs() < 16) {
                        setState(() => _tradeLines.removeAt(i));
                        break;
                      }
                    }
                  },
                  child: CustomPaint(
                    size: Size.infinite,
                    painter: _LinesPainter(
                      candles: _candles,
                      tradeLines: allLines,
                      currentPrice: _currentPrice,
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}

class _LinesPainter extends CustomPainter {
  final List<Candle> candles;
  final List<TradeLine> tradeLines;
  final double? currentPrice;

  _LinesPainter({
    required this.candles,
    required this.tradeLines,
    required this.currentPrice,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (candles.isEmpty) return;

    final minP = candles.map((c) => c.low).reduce(min);
    final maxP = candles.map((c) => c.high).reduce(max);
    double priceToY(double price) {
      if (maxP == minP) return size.height / 2;
      return (maxP - price) / (maxP - minP) * size.height;
    }

    final linePaint = Paint()..strokeWidth = 2.0;

    for (final line in tradeLines) {
      if (line.type == TradeLineType.entry) {
        linePaint.color = Colors.yellow;
      } else if (line.type == TradeLineType.sl) {
        linePaint.color = Colors.red;
      } else {
        linePaint.color = Colors.green;
      }

      final y = priceToY(line.price);
      canvas.drawLine(Offset(0, y), Offset(size.width, y), linePaint);

      final tp = TextPainter(
        text: TextSpan(
          text: "${line.type.name.toUpperCase()} ${line.price.toStringAsFixed(2)}",
          style: const TextStyle(color: Colors.white, fontSize: 12),
        ),
        textDirection: TextDirection.ltr,
      );
      tp.layout();
      tp.paint(canvas, Offset(size.width - tp.width - 8, y - tp.height));
    }

    // ✅ Ligne du prix actuel
    if (currentPrice != null) {
      final y = priceToY(currentPrice!);
      final p = Paint()
        ..color = Colors.white70
        ..strokeWidth = 1.0;
      canvas.drawLine(Offset(0, y), Offset(size.width, y), p);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
