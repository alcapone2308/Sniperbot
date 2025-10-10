import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/trade_provider.dart';
import '../providers/wallet_provider.dart';
import '../models/trade.dart';
import '../widgets/realtime_chart.dart';
import 'trade_history_page.dart';

class TradeSimulatorPage extends StatefulWidget {
  const TradeSimulatorPage({super.key});

  @override
  State<TradeSimulatorPage> createState() => _TradeSimulatorPageState();
}

class _TradeSimulatorPageState extends State<TradeSimulatorPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final _formKey = GlobalKey<FormState>();
  final _symbolCtrl = TextEditingController(text: 'BTCUSDT');
  final _qtyCtrl = TextEditingController(text: '0.01');
  final _entryCtrl = TextEditingController(text: '0');
  final _slCtrl = TextEditingController();
  final _tpCtrl = TextEditingController();

  double _lastPrice = 0;
  Trade? _current;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _symbolCtrl.dispose();
    _qtyCtrl.dispose();
    _entryCtrl.dispose();
    _slCtrl.dispose();
    _tpCtrl.dispose();
    super.dispose();
  }

  void _open(TradeProvider tProv) {
    if (!_formKey.currentState!.validate()) return;

    final symbol = _symbolCtrl.text.trim().toUpperCase();
    final qty = double.parse(_qtyCtrl.text);
    final entry = double.tryParse(_entryCtrl.text) ?? 0;
    final sl = _slCtrl.text.isEmpty ? null : double.parse(_slCtrl.text);
    final tp = _tpCtrl.text.isEmpty ? null : double.parse(_tpCtrl.text);

    final entryPrice = (entry <= 0) ? _lastPrice : entry;
    if (entryPrice <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Prix d’entrée invalide (attends un tick)')));
      return;
    }

    final side =
    (tp != null && tp < entryPrice) ? TradeSide.sell : TradeSide.buy;
    final trade = tProv.openTrade(
      symbol: symbol,
      side: side,
      qty: qty,
      entryPrice: entryPrice,
      sl: sl,
      tp: tp,
    );

    setState(() => _current = trade);
  }

  void _closeNow(TradeProvider tProv, WalletProvider w) {
    if (_current == null) return;
    final closed = tProv.closeTrade(
      tradeId: _current!.id,
      closePrice: _lastPrice,
      reason: "manual",
    );
    if (closed != null) {
      w.applyClosedTrade(closed);
      setState(() => _current = null);
    }
  }

  @override
  Widget build(BuildContext context) {
    final tProv = context.watch<TradeProvider>();
    final wallet = context.watch<WalletProvider>();
    final trades = tProv.trades;

    final openForSymbol = tProv.openTrades
        .where((t) => t.symbol == _symbolCtrl.text.toUpperCase())
        .toList();
    if (_current == null && openForSymbol.isNotEmpty) {
      _current = openForSymbol.first;
    }

    return Scaffold(
      backgroundColor: const Color(0xFF0A0E1A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1A1F2E),
        title: const Text('🎯 Simulateur de Trade'),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.orange,
          labelColor: Colors.orange,
          unselectedLabelColor: Colors.white70,
          tabs: const [
            Tab(text: "Vue d'ensemble"),
            Tab(text: "Simulateur"),
            Tab(text: "Historique"),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildOverview(wallet, trades),
          _buildSimulator(wallet, tProv),
          const TradeHistoryPage(),
        ],
      ),
    );
  }

  // 🟠 Onglet 1 — Vue d’ensemble
  Widget _buildOverview(WalletProvider wallet, List<Trade> trades) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Colors.orange, Colors.deepOrangeAccent],
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                const Text(
                  "Solde total",
                  style: TextStyle(fontSize: 16, color: Colors.white70),
                ),
                Text(
                  "\$${wallet.balance.toStringAsFixed(2)}",
                  style: const TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("PnL Réalisé: \$${wallet.realizedPnL.toStringAsFixed(2)}",
                        style: const TextStyle(color: Colors.white)),
                    Text("Trades: ${trades.length}",
                        style: const TextStyle(color: Colors.white)),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: GridView.count(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              children: [
                _statCard("Meilleur trade",
                    "\$${wallet.bestTrade.toStringAsFixed(2)}", Colors.green),
                _statCard("Pire trade",
                    "\$${wallet.worstTrade.toStringAsFixed(2)}", Colors.red),
                _statCard("Trades ouverts",
                    "${trades.where((t) => t.isOpen).length}", Colors.orange),
                _statCard("Positions clôturées",
                    "${trades.where((t) => !t.isOpen).length}", Colors.blue),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _statCard(String title, String value, Color color) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.black45,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(value,
              style: TextStyle(
                  color: color, fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Text(title,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.white70, fontSize: 14)),
        ],
      ),
    );
  }

  // 🟢 Onglet 2 — Simulateur
  Widget _buildSimulator(WalletProvider wallet, TradeProvider tProv) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Text(
            "💹 Simulateur de Trade (${_symbolCtrl.text.toUpperCase()})",
            style: TextStyle(
                color: Colors.orange.shade300, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            "Dernier prix : ${_lastPrice.toStringAsFixed(2)} USDT",
            style: const TextStyle(color: Colors.white70),
          ),
          const SizedBox(height: 10),
          SizedBox(
            height: 250,
            child: RealtimeChart(
              symbol: _symbolCtrl.text.trim(),
              onPrice: (p) {
                _lastPrice = p;
                if (_current != null) {
                  final closed = tProv.checkAutoClose(
                      symbol: _current!.symbol, currentPrice: p);
                  if (closed.isNotEmpty) {
                    for (final c in closed) {
                      wallet.applyClosedTrade(c);
                    }
                    if (mounted) setState(() => _current = null);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                          content: Text(
                              'Position fermée automatiquement (${closed.first.closeReason})')),
                    );
                  }
                }
                if (mounted) setState(() {});
              },
            ),
          ),
          const SizedBox(height: 16),
          _orderForm(tProv),
          const SizedBox(height: 16),
          _openPositionCard(tProv, wallet),
        ],
      ),
    );
  }

  Widget _orderForm(TradeProvider tProv) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1F2E),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white12),
      ),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            Row(children: [
              Expanded(
                child: TextFormField(
                  controller: _symbolCtrl,
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    labelText: 'Symbole',
                    labelStyle: TextStyle(color: Colors.white70),
                    enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white24)),
                    focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.orange)),
                  ),
                  validator: (v) =>
                  (v == null || v.trim().isEmpty) ? 'Obligatoire' : null,
                  onEditingComplete: () => setState(() {}),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: TextFormField(
                  controller: _qtyCtrl,
                  keyboardType: TextInputType.number,
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    labelText: 'Quantité',
                    labelStyle: TextStyle(color: Colors.white70),
                    enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white24)),
                    focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.orange)),
                  ),
                  validator: (v) {
                    final d = double.tryParse(v ?? '');
                    if (d == null || d <= 0) return 'Quantité invalide';
                    return null;
                  },
                ),
              ),
            ]),
            const SizedBox(height: 10),
            Row(children: [
              Expanded(
                child: TextFormField(
                  controller: _entryCtrl,
                  keyboardType: TextInputType.number,
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    labelText: 'Prix entrée (0 = courant)',
                    labelStyle: TextStyle(color: Colors.white70),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: TextFormField(
                  controller: _slCtrl,
                  keyboardType: TextInputType.number,
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    labelText: 'SL (optionnel)',
                    labelStyle: TextStyle(color: Colors.white70),
                  ),
                ),
              ),
            ]),
            const SizedBox(height: 10),
            Row(children: [
              Expanded(
                child: TextFormField(
                  controller: _tpCtrl,
                  keyboardType: TextInputType.number,
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    labelText: 'TP (optionnel)',
                    labelStyle: TextStyle(color: Colors.white70),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              SizedBox(
                height: 48,
                child: ElevatedButton.icon(
                  onPressed: () => _open(tProv),
                  icon: const Icon(Icons.play_arrow),
                  label: const Text('Ouvrir'),
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepOrange),
                ),
              ),
            ]),
          ],
        ),
      ),
    );
  }

  Widget _openPositionCard(TradeProvider tProv, WalletProvider w) {
    final trade = _current;
    if (trade == null) {
      return Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: const Color(0xFF111626),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.white12),
        ),
        child: const Text('Aucune position ouverte',
            style: TextStyle(color: Colors.white60)),
      );
    }

    final sideStr = trade.side == TradeSide.buy ? 'LONG' : 'SHORT';
    final pnl = (trade.side == TradeSide.buy)
        ? ((_lastPrice - trade.entryPrice) * trade.qty)
        : ((trade.entryPrice - _lastPrice) * trade.qty);

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1F2E),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('${trade.symbol} • $sideStr',
              style: const TextStyle(
                  color: Colors.white, fontWeight: FontWeight.bold)),
          const SizedBox(height: 6),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Entrée: ${trade.entryPrice.toStringAsFixed(2)}',
                  style: const TextStyle(color: Colors.white70)),
              Text('Prix: ${_lastPrice.toStringAsFixed(2)}',
                  style: const TextStyle(color: Colors.white70)),
            ],
          ),
          const SizedBox(height: 6),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('SL: ${trade.sl?.toStringAsFixed(2) ?? "-"}',
                  style: const TextStyle(color: Colors.white54)),
              Text('TP: ${trade.tp?.toStringAsFixed(2) ?? "-"}',
                  style: const TextStyle(color: Colors.white54)),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(
                    color: Colors.black26,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.white12),
                  ),
                  child: Column(
                    children: [
                      const Text('PnL (non réalisé)',
                          style:
                          TextStyle(color: Colors.white60, fontSize: 12)),
                      const SizedBox(height: 4),
                      Text(
                        pnl.toStringAsFixed(2),
                        style: TextStyle(
                          color: pnl >= 0
                              ? Colors.greenAccent
                              : Colors.redAccent,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 12),
              SizedBox(
                height: 44,
                child: ElevatedButton.icon(
                  onPressed: () => _closeNow(tProv, w),
                  icon: const Icon(Icons.close),
                  label: const Text('Clôturer'),
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.redAccent),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
