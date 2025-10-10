import 'package:flutter/material.dart';
import 'dart:async';

class StructureHunterPage extends StatefulWidget {
  const StructureHunterPage({super.key});

  @override
  State<StructureHunterPage> createState() => _StructureHunterPageState();
}

class _StructureHunterPageState extends State<StructureHunterPage> {
  int currentLevel = 0;
  int score = 0;
  int lives = 3;
  bool showFeedback = false;
  bool correct = false;
  bool debugMode = false; // ⚙️ mettre true pour calibrer visuellement

  final List<_Level> levels = [
    _Level(
      imagePath: "assets/images/game_bos_level1.png",
      targetArea: const Rect.fromLTWH(0.67, 0.18, 0.08, 0.10),
      title: "BOS haussier",
    ),
    _Level(
      imagePath: "assets/images/game_bos_level1-1.png",
      targetArea: const Rect.fromLTWH(0.63, 0.22, 0.10, 0.12),
      title: "Cassure de structure",
    ),
    _Level(
      imagePath: "assets/images/game_bos_level1-2.png",
      targetArea: const Rect.fromLTWH(0.60, 0.30, 0.15, 0.12),
      title: "Cassure finale du BOS",
    ),
  ];

  void _handleTap(TapUpDetails details, BuildContext context) {
    if (showFeedback) return;
    final RenderBox box = context.findRenderObject() as RenderBox;
    final size = box.size;
    final tapPosition = details.localPosition;

    final normalizedTap = Offset(
      tapPosition.dx / size.width,
      tapPosition.dy / size.height,
    );

    final target = levels[currentLevel].targetArea;

    // ✅ Tolérance agrandie pour zone cliquable
    final expandedTarget = Rect.fromLTRB(
      target.left - 0.05,
      target.top - 0.05,
      target.right + 0.05,
      target.bottom + 0.05,
    );

    final isCorrect = expandedTarget.contains(normalizedTap);

    setState(() {
      showFeedback = true;
      correct = isCorrect;
    });

    if (isCorrect) {
      score += 10;
    } else {
      lives--;
    }

    Timer(const Duration(seconds: 1), () {
      if (!mounted) return;
      setState(() => showFeedback = false);

      if (isCorrect) {
        if (currentLevel < levels.length - 1) {
          setState(() => currentLevel++);
        } else {
          _showEndDialog();
        }
      } else if (lives <= 0) {
        _showGameOver();
      }
    });
  }

  void _showEndDialog() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: Colors.black87,
        title: const Text("🎉 Niveau complété !",
            style: TextStyle(color: Colors.orangeAccent)),
        content: Text("Score final : $score",
            style: const TextStyle(color: Colors.white)),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child:
            const Text("Fermer", style: TextStyle(color: Colors.orangeAccent)),
          ),
        ],
      ),
    );
  }

  void _showGameOver() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: Colors.black87,
        title: const Text("💀 Partie terminée",
            style: TextStyle(color: Colors.redAccent)),
        content: Text("Score final : $score",
            style: const TextStyle(color: Colors.white)),
        actions: [
          TextButton(
            onPressed: () {
              setState(() {
                score = 0;
                lives = 3;
                currentLevel = 0;
              });
              Navigator.pop(context);
            },
            child:
            const Text("Rejouer", style: TextStyle(color: Colors.orangeAccent)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final level = levels[currentLevel];

    return Scaffold(
      appBar: AppBar(
        title: const Text("Mini-Jeu : Chasseur de Structure"),
        backgroundColor: Colors.deepOrange,
      ),
      body: Stack(
        children: [
          // 🌆 fond dégradé
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF1E1E2E), Color(0xFF0D0D0D)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),

          // 💹 Image du graphique
          Center(
            child: AspectRatio(
              aspectRatio: 16 / 9,
              child: Container(
                margin: const EdgeInsets.only(top: 40), // 🟢 image plus haute
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.white24, width: 1),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black38,
                      blurRadius: 10,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                clipBehavior: Clip.hardEdge,
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: Image.asset(level.imagePath, fit: BoxFit.contain),
                    ),
                    GestureDetector(
                      onTapUp: (details) => _handleTap(details, context),
                      child: Container(color: Colors.transparent),
                    ),

                    // 🧭 Rectangle de calibration (uniquement en debug)
                    if (debugMode)
                      LayoutBuilder(
                        builder: (context, constraints) {
                          final rect = level.targetArea;
                          return Positioned(
                            left: rect.left * constraints.maxWidth,
                            top: rect.top * constraints.maxHeight,
                            width: rect.width * constraints.maxWidth,
                            height: rect.height * constraints.maxHeight,
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.green.withOpacity(0.25),
                                border: Border.all(
                                    color: Colors.greenAccent, width: 2),
                              ),
                            ),
                          );
                        },
                      ),

                    // ✅ Feedback visuel (vert/rouge)
                    if (showFeedback)
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        color: correct
                            ? Colors.green.withOpacity(0.3)
                            : Colors.red.withOpacity(0.3),
                        child: Center(
                          child: Text(
                            correct ? "✅ Correct !" : "❌ Raté !",
                            style: TextStyle(
                              color: correct
                                  ? Colors.greenAccent
                                  : Colors.redAccent,
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              shadows: const [
                                Shadow(
                                    color: Colors.black,
                                    blurRadius: 10,
                                    offset: Offset(0, 2))
                              ],
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),

          // 🔝 HUD (score, vies, niveau)
          Positioned(
            top: 10,
            left: 10,
            right: 10,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _hudBox("❤️ Vies", "$lives"),
                _hudBox("🏆 Score", "$score"),
                _hudBox("📈 Niveau", "${currentLevel + 1}/${levels.length}"),
              ],
            ),
          ),

          // 📄 titre
          Positioned(
            bottom: 30,
            left: 0,
            right: 0,
            child: Column(
              children: [
                Text(level.title,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.orangeAccent)),
                const SizedBox(height: 8),
                const Text(
                  "Repère la cassure de structure (BOS) sur le graphique.",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white70),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _hudBox(String label, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.black54,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.white24),
      ),
      child: Column(
        children: [
          Text(label,
              style: const TextStyle(color: Colors.white70, fontSize: 12)),
          Text(value,
              style: const TextStyle(
                  color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}

class _Level {
  final String imagePath;
  final Rect targetArea;
  final String title;

  const _Level({
    required this.imagePath,
    required this.targetArea,
    required this.title,
  });
}
