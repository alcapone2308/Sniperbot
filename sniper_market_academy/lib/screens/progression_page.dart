import 'package:flutter/material.dart';

class ProgressionPage extends StatelessWidget {
  const ProgressionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Suivi de progression'),
        backgroundColor: Colors.deepOrange,
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/menu_background.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            const Text(
              'Progression Générale',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            const SizedBox(height: 20),
            _buildProgressBar('Modules SMC', 0.6),
            const SizedBox(height: 20),
            _buildProgressBar('Exercices SMC', 0.45),
            const SizedBox(height: 20),
            _buildProgressBar('Temps total passé', 0.3),
            const SizedBox(height: 40),
            const Text(
              'Historique des modules terminés',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            const SizedBox(height: 10),
            _buildModuleTile('Structure du Marché', true),
            _buildModuleTile('Break of Structure (BOS)', true),
            _buildModuleTile('Fair Value Gap (FVG)', true),
            _buildModuleTile('OTE', false),
            _buildModuleTile('Liquidity', false),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressBar(String title, double progress) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(color: Colors.white, fontSize: 16),
        ),
        const SizedBox(height: 8),
        LinearProgressIndicator(
          value: progress,
          minHeight: 10,
          backgroundColor: Colors.white24,
          color: Colors.orangeAccent,
        ),
      ],
    );
  }

  Widget _buildModuleTile(String title, bool completed) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      tileColor: Colors.white.withOpacity(0.15),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      leading: Icon(
        completed ? Icons.check_circle : Icons.radio_button_unchecked,
        color: completed ? Colors.greenAccent : Colors.white,
      ),
      title: Text(
        title,
        style: const TextStyle(color: Colors.white, fontSize: 16),
      ),
    );
  }
}
