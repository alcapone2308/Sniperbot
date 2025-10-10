import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/trade_provider.dart';
import '../models/trade.dart';

class TradeHistoryPage extends StatelessWidget {
  const TradeHistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    final closed = context.watch<TradeProvider>().closedTrades;

    return Scaffold(
      appBar: AppBar(title: const Text('Historique des trades')),
      backgroundColor: const Color(0xFF0A0E1A),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemCount: closed.length,
        itemBuilder: (_, i) {
          final t = closed[i];
          final pnl = t.pnl ?? 0;
          final isWin = pnl >= 0;
          return Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFF1A1F2E),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.white12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('${t.symbol}  •  ${t.side == TradeSide.buy ? 'LONG' : 'SHORT'}',
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                const SizedBox(height: 6),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Entrée: ${t.entryPrice.toStringAsFixed(2)}', style: const TextStyle(color: Colors.white70)),
                    Text('Sortie: ${(t.closePrice ?? 0).toStringAsFixed(2)}', style: const TextStyle(color: Colors.white70)),
                  ],
                ),
                const SizedBox(height: 6),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Qté: ${t.qty}', style: const TextStyle(color: Colors.white70)),
                    Text(
                      'PnL: ${pnl.toStringAsFixed(2)}',
                      style: TextStyle(color: isWin ? Colors.greenAccent : Colors.redAccent, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text('Raison: ${t.closeReason ?? "-"}', style: const TextStyle(color: Colors.white38, fontSize: 12)),
                Text('Fermé: ${t.closedAt?.toLocal().toString().replaceFirst('.000', '')}',
                    style: const TextStyle(color: Colors.white24, fontSize: 12)),
              ],
            ),
          );
        },
      ),
    );
  }
}
