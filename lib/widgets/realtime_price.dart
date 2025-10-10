import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

typedef PriceCallback = void Function(double price);

class RealtimePrice extends StatefulWidget {
  final String symbol; // ex: BTCUSDT, ETHUSDT
  final PriceCallback onPrice;
  final Duration refresh;

  const RealtimePrice({
    super.key,
    required this.symbol,
    required this.onPrice,
    this.refresh = const Duration(seconds: 5),
  });

  @override
  State<RealtimePrice> createState() => _RealtimePriceState();
}

class _RealtimePriceState extends State<RealtimePrice> {
  double? _price;
  Timer? _timer;

  Future<void> _fetch() async {
    try {
      final uri = Uri.parse('https://api.binance.com/api/v3/ticker/price?symbol=${widget.symbol}');
      final res = await http.get(uri).timeout(const Duration(seconds: 8));
      if (res.statusCode == 200) {
        final data = json.decode(res.body);
        final p = double.parse(data['price']);
        setState(() => _price = p);
        widget.onPrice(p);
      }
    } catch (_) {
      // ignore silently
    }
  }

  @override
  void initState() {
    super.initState();
    _fetch();
    _timer = Timer.periodic(widget.refresh, (_) => _fetch());
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.black54,
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(14.0),
        child: Row(
          children: [
            const Icon(Icons.show_chart, color: Colors.orangeAccent),
            const SizedBox(width: 10),
            Text(
              widget.symbol,
              style: const TextStyle(color: Colors.white70, fontWeight: FontWeight.w600),
            ),
            const Spacer(),
            Text(
              _price == null ? "—" : _price!.toStringAsFixed(2),
              style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
