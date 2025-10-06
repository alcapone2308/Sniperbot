import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/trade_provider.dart';
import '../models/trade.dart';

class TradeHistoryPage extends StatelessWidget {
  const TradeHistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    final tradeProvider = Provider.of<TradeProvider>(context);
    final history = tradeProvider.history;

    return Scaffold(
      appBar: AppBar(
        title: const Text("📜 Historique des Trades"),
        backgroundColor: Colors.deepOrange,
      ),
      body: history.isEmpty
          ? const Center(
        child: Text(
          "Aucun trade enregistré pour l’instant.",
          style: TextStyle(color: Colors.white70, fontSize: 16),
        ),
      )
          : ListView.builder(
        itemCount: history.length,
        itemBuilder: (context, index) {
          final Trade trade = history[index];
          final isWin = trade.result > 0;
          final isLoss = trade.result < 0;

          return Card(
            color: Colors.black54,
            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor:
                isWin ? Colors.green : (isLoss ? Colors.red : Colors.grey),
                child: Icon(
                  isWin
                      ? Icons.check
                      : (isLoss ? Icons.close : Icons.remove),
                  color: Colors.white,
                ),
              ),
              title: Text(
                "${trade.symbol} | Entry: ${trade.entry} | SL: ${trade.sl} | TP: ${trade.tp}",
                style: const TextStyle(color: Colors.white, fontSize: 14),
              ),
              subtitle: Text(
                "Date : ${trade.date.toLocal().toString().split(' ')[0]}",
                style: const TextStyle(color: Colors.white70, fontSize: 12),
              ),
              trailing: Text(
                trade.result > 0
                    ? "+${trade.result} pts"
                    : (trade.result < 0 ? "${trade.result} pts" : "0 pts"),
                style: TextStyle(
                  color: isWin
                      ? Colors.greenAccent
                      : (isLoss ? Colors.redAccent : Colors.white70),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          );
        },
      ),
      backgroundColor: Colors.black,
    );
  }
}
