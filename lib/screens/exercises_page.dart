import 'package:flutter/material.dart';
import 'trade_simulator_page.dart';

class ExercisesPage extends StatelessWidget {
  const ExercisesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("🧠 Exercices SMC"),
        backgroundColor: Colors.deepPurple,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildExerciseCard(
            context,
            title: "Exercice BOS",
            description: "Identifie les Break of Structure sur un graphique.",
            routeName: '/bos_exercise',
          ),
          _buildExerciseCard(
            context,
            title: "Exercice FVG",
            description: "Repère les Fair Value Gaps sur le graphique.",
            routeName: '/fvg_exercise',
          ),
          _buildExerciseCard(
            context,
            title: "Exercice OTE",
            description: "Détermine la zone d'entrée optimale.",
            routeName: '/ote_exercice1',
          ),
          _buildExerciseCard(
            context,
            title: "Exercice Liquidité",
            description: "Repère une chasse de liquidité sur le graphique.",
            routeName: '/liquidity_exercice1',
          ),
          _buildExerciseCard(
            context,
            title: "Exercice Order Block",
            description: "Identifie un Order Block valide.",
            routeName: '/orderblock_exercice1',
          ),
          _buildExerciseCard(
            context,
            title: "Exercice Displacement",
            description: "Repère une impulsion valide (Displacement).",
            routeName: '/displacement_exercice1',
          ),
          _buildExerciseCard(
            context,
            title: "Exercice Scalp Ready",
            description: "Analyse un setup de scalp complet.",
            routeName: '/scalp_ready_exercise1',
          ),
          _buildExerciseCard(
            context,
            title: "Exercice Setup Complet",
            description: "Valide un setup entier basé sur SMC.",
            routeName: '/setup_complet_exercise',
          ),
          _buildExerciseCard(
            context,
            title: "Quiz ICT",
            description: "Teste tes connaissances ICT/SMC.",
            routeName: '/ict_quiz',
          ),
          _buildExerciseCard(
            context,
            title: "📈 Simulateur de Trade",
            description:
            "Remplis manuellement un trade et reçois un feedback immédiat.",
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const TradeSimulatorPage()),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildExerciseCard(
      BuildContext context, {
        required String title,
        required String description,
        String? routeName,
        VoidCallback? onTap,
      }) {
    return Card(
      color: Colors.black87,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: ListTile(
        leading: const Icon(Icons.play_circle_fill,
            color: Colors.orange, size: 30),
        title: Text(title, style: const TextStyle(color: Colors.white)),
        subtitle:
        Text(description, style: const TextStyle(color: Colors.white70)),
        trailing: const Icon(Icons.chevron_right, color: Colors.white),
        onTap: onTap ??
                () {
              if (routeName != null) {
                Navigator.pushNamed(context, routeName);
              }
            },
      ),
    );
  }
}
