import 'package:flutter/material.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

class DisplacementModule extends StatefulWidget {
  const DisplacementModule({super.key});

  @override
  State<DisplacementModule> createState() => _DisplacementModuleState();
}

class _DisplacementModuleState extends State<DisplacementModule> {
  late YoutubePlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = YoutubePlayerController(
      params: const YoutubePlayerParams(
        showControls: true,
        showFullscreenButton: true,
      ),
    )..loadVideoById(videoId: 'IsAr_Sox1Cw'); // ID YouTube
  }

  @override
  void dispose() {
    _controller.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return YoutubePlayerScaffold(
      controller: _controller,
      builder: (context, player) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('💥 DISPLACEMENT - L\'arme secrète des pros'),
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
                // Header
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.deepOrange, width: 2),
                  ),
                  child: const Column(
                    children: [
                      Text(
                        'LE DISPLACEMENT EN 3 CLÉS',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Décryptez les mouvements institutionnels',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 25),

                // Image
                Card(
                  elevation: 10,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.asset(
                      'assets/images/displacement_module_explained.png',
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                const SizedBox(height: 25),

                // Contenu pédagogique
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.6),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '🔍 Ce qu\'il faut savoir :',
                        style: TextStyle(
                          color: Colors.orange,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        'Le displacement est une bougie PUISSANTE qui montre:\n'
                            '• Un déséquilibre brutal entre acheteurs/vendeurs\n'
                            '• L\'intervention des institutions\n'
                            '• Un point de bascule du marché',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          height: 1.6,
                        ),
                      ),
                      SizedBox(height: 20),
                      Text(
                        '📌 Comment l\'identifier ?',
                        style: TextStyle(
                          color: Colors.orange,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        '1️⃣ Une bougie 3x plus grande que la moyenne\n'
                            '2️⃣ Peu ou pas d\'ombre (prix contrôlé)\n'
                            '3️⃣ Génère un FVG (zone de déséquilibre)\n'
                            '4️⃣ Survient après un run de liquidité',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          height: 1.8,
                        ),
                      ),
                      SizedBox(height: 20),
                      Text(
                        '🎯 Stratégie pro :',
                        style: TextStyle(
                          color: Colors.orange,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        'Tradez le retour vers le FVG créé avec:\n'
                            '• Entrée: 50-61.8% retracement\n'
                            '• Stop Loss: Au-delà du point d\'origine\n'
                            '• Take Profit: Vers les prochaines liquidités',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          height: 1.6,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 30),

                // Zone vidéo
                const Text(
                  '🎬 Explication vidéo détaillée :',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                player,
                const SizedBox(height: 30),

                // Quiz interactif
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Colors.deepOrange, Colors.orange],
                    ),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.orange.withOpacity(0.4),
                        spreadRadius: 2,
                        blurRadius: 10,
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      const Text(
                        'TESTEZ VOTRE COMPRÉHENSION',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                          foregroundColor: Colors.orange,
                          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        onPressed: () {},
                        child: const Text('Démarrer le quiz pratique'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}