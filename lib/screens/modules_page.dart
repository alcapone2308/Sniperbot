import 'package:flutter/material.dart';
import 'market_structure.dart';
import 'bos_module.dart';
import 'fvg_module.dart';
import 'ote_module.dart';
import 'liquidity_module.dart';
import 'displacement_module.dart';
import 'orderblock_module.dart'; // ✅ Import du module OB

class ModulesPage extends StatelessWidget {
  const ModulesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> modules = [
      {
        'title': 'Structure du Marché',
        'page': const MarketStructure()
      },
      {
        'title': 'Break of Structure (BOS)',
        'page': const BOSModule()
      },
      {
        'title': 'Fair Value Gap (FVG)',
        'page': const FVGModule()
      },
      {
        'title': 'OTE - Optimal Trade Entry',
        'page': const OTEModule()
      },
      {
        'title': 'Liquidité',
        'page': const LiquidityModule()
      },
      {
        'title': 'Displacement',
        'page': const DisplacementModule()
      },
      {
        'title': 'Order Block (OB)', // ✅ Nouveau titre
        'page': const OrderBlockModule() // ✅ Nouvelle page
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Modules Théoriques'),
        backgroundColor: Colors.deepOrange,
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/menu_background.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: ListView.builder(
          padding: const EdgeInsets.all(20),
          itemCount: modules.length,
          itemBuilder: (context, index) {
            final module = modules[index];
            return Card(
              color: Colors.black.withOpacity(0.4),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              margin: const EdgeInsets.symmetric(vertical: 8),
              child: ListTile(
                title: Text(
                  module['title'] as String,
                  style: const TextStyle(color: Colors.white),
                ),
                trailing: const Icon(Icons.arrow_forward_ios, color: Colors.white),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => module['page'] as Widget,
                    ),
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
