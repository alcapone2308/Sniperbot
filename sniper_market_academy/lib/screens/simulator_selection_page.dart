import 'package:flutter/material.dart';
import 'package:sniper_market_academy/screens/simulateur_page.dart';


class SimulatorSelectionPage extends StatelessWidget {
  const SimulatorSelectionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('📊 Choisir un exercice de simulation'),
        backgroundColor: Colors.black87,
      ),
      backgroundColor: Colors.black,
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: 4, // nombre d’images chart_*.png disponibles
        itemBuilder: (context, index) {
          final chartNumber = index + 1;
          return Card(
            color: Colors.grey[900],
            margin: const EdgeInsets.symmetric(vertical: 8),
            child: ListTile(
              title: Text(
                'Exercice Simulation #$chartNumber',
                style: const TextStyle(color: Colors.white),
              ),
              trailing: const Icon(Icons.arrow_forward_ios, color: Colors.white),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => SimulateurPage(chartNumber: chartNumber),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
