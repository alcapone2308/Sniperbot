import 'package:flutter/material.dart';

class ScalpReadyAssistantPage extends StatelessWidget {
  const ScalpReadyAssistantPage({super.key});

  void _showFeedback(BuildContext context, String feedback) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Analyse'),
        content: Text(feedback),
        actions: [
          TextButton(
            child: const Text('Fermer'),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Scalp Ready Assistant')),
      body: Stack(
        children: [
          // Image du scénario
          Positioned.fill(
            child: Image.asset(
              'assets/images/placeholder.png',
              fit: BoxFit.cover,
            ),
          ),
          // Zone A - haut gauche
          Positioned(
            left: 50,
            top: 150,
            width: 100,
            height: 100,
            child: GestureDetector(
              onTap: () => _showFeedback(context, '❌ Mauvais choix : zone de liquidity prise.'),
              child: Container(color: Colors.transparent),
            ),
          ),
          // Zone B - bas droite
          Positioned(
            right: 50,
            bottom: 150,
            width: 100,
            height: 100,
            child: GestureDetector(
              onTap: () => _showFeedback(context, '✅ Bien joué ! Entrée logique après BOS.'),
              child: Container(color: Colors.transparent),
            ),
          ),
        ],
      ),
    );
  }
}
