import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/wallet_provider.dart';

class WalletPage extends StatelessWidget {
  const WalletPage({super.key});

  @override
  Widget build(BuildContext context) {
    final wallet = context.watch<WalletProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Portefeuille'),
        backgroundColor: const Color(0xFF1A1F2E),
      ),
      backgroundColor: const Color(0xFF0A0E1A),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _metric('Solde actuel', wallet.balance.toStringAsFixed(2), Icons.account_balance_wallet),
            const SizedBox(height: 10),
            _metric('PnL réalisé', wallet.realizedPnL.toStringAsFixed(2), Icons.trending_up),
            const SizedBox(height: 10),
            _metric('Meilleur trade', wallet.bestTrade.toStringAsFixed(2), Icons.star),
            const SizedBox(height: 10),
            _metric('Pire trade', wallet.worstTrade.toStringAsFixed(2), Icons.warning),
            const SizedBox(height: 30),
            const Text(
              "Les trades fermés sont automatiquement enregistrés et mis à jour ici depuis le simulateur.",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white54),
            ),
          ],
        ),
      ),
    );
  }

  Widget _metric(String label, String value, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1F2E),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white12),
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.orangeAccent),
          const SizedBox(width: 12),
          Expanded(
            child: Text(label, style: const TextStyle(color: Colors.white70, fontSize: 16)),
          ),
          Text(
            value,
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
