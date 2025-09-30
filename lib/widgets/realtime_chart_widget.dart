import 'package:flutter/material.dart';
import 'package:candlesticks/candlesticks.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

class RealtimeChartWidget extends StatefulWidget {
  const RealtimeChartWidget({super.key});

  @override
  State<RealtimeChartWidget> createState() => _RealtimeChartWidgetState();
}

class _RealtimeChartWidgetState extends State<RealtimeChartWidget> {
  List<Candle> candles = [];
  Timer? _timer;

  final String symbol = 'XAUUSDT'; // Binance cote l'or en USDT
  String interval = '1m'; // intervalle par défaut
  final int limit = 30;

  @override
  void initState() {
    super.initState();
    _fetchCandles();
    _timer = Timer.periodic(const Duration(seconds: 5), (_) => _fetchCandles());
  }

  Future<void> _fetchCandles() async {
    try {
      final url = Uri.parse(
        'https://api.binance.com/api/v3/klines?symbol=$symbol&interval=$interval&limit=$limit',
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

        setState(() => candles = parsed);
      } else {
        debugPrint("Erreur Binance: ${response.body}");
      }
    } catch (e) {
      debugPrint('Erreur chargement Binance bougies : $e');
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (candles.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    return Column(
      children: [
        // ✅ Sélecteur d’intervalle
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: DropdownButton<String>(
            value: interval,
            items: ["1m", "5m", "15m", "1h", "4h", "1d"].map((iv) {
              return DropdownMenuItem(
                value: iv,
                child: Text(iv),
              );
            }).toList(),
            onChanged: (val) {
              if (val != null) {
                setState(() => interval = val);
                _fetchCandles();
              }
            },
          ),
        ),

        // ✅ Graphique
        Expanded(
          child: Candlesticks(
            candles: candles,
          ),
        ),
      ],
    );
  }
}
