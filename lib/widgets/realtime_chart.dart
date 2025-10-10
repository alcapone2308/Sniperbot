import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:candlesticks/candlesticks.dart';
import 'package:http/http.dart' as http;

class RealtimeChart extends StatefulWidget {
  final String symbol; // Exemple : "BTCUSDT"
  final ValueChanged<double>? onPrice; // callback pour propager le prix

  const RealtimeChart({
    super.key,
    required this.symbol,
    this.onPrice,
  });

  @override
  State<RealtimeChart> createState() => _RealtimeChartState();
}

class _RealtimeChartState extends State<RealtimeChart> {
  List<Candle> _candles = [];
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _fetchCandles();
    // Mise à jour auto toutes les 5 secondes
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
          "https://api.binance.com/api/v3/klines?symbol=${widget.symbol}&interval=1m&limit=50");
      final res = await http.get(url);
      if (res.statusCode == 200) {
        final data = json.decode(res.body) as List<dynamic>;
        final candles = data.map((e) {
          return Candle(
            date: DateTime.fromMillisecondsSinceEpoch(e[0]),
            open: double.parse(e[1]),
            high: double.parse(e[2]),
            low: double.parse(e[3]),
            close: double.parse(e[4]),
            volume: double.parse(e[5]),
          );
        }).toList();

        if (candles.isNotEmpty) {
          final last = candles.last.close;
          widget.onPrice?.call(last);
        }

        setState(() => _candles = candles);
      }
    } catch (e) {
      debugPrint("Erreur chargement bougies : $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 280,
      decoration: BoxDecoration(
        color: const Color(0xFF0E1117),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white12),
      ),
      child: _candles.isEmpty
          ? const Center(
        child: CircularProgressIndicator(color: Colors.orange),
      )
          : Candlesticks(
        candles: _candles,
      ),
    );
  }
}
