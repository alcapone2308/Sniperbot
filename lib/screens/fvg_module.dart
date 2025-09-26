import 'package:flutter/material.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

class FVGModule extends StatefulWidget {
  const FVGModule({super.key});

  @override
  State<FVGModule> createState() => _FVGModuleState();
}

class _FVGModuleState extends State<FVGModule> {
  late YoutubePlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = YoutubePlayerController(
      params: const YoutubePlayerParams(
        showControls: true,
        showFullscreenButton: true,
      ),
    )..loadVideoById(videoId: 'skk0sm6LN6M');
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
            title: const Text('🟧 FVG - Zones d\'opportunité'),
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
                // Header avec effet visuel
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Colors.deepOrange, Colors.orange],
                    ),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.deepOrange.withOpacity(0.4),
                        blurRadius: 10,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: const Column(
                    children: [
                      Text(
                        'FAIR VALUE GAP (FVG)',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Le point faible des institutions',
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

                // Image explicative
                Card(
                  elevation: 10,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.asset(
                      'assets/images/fvg_module_explained.png',
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                const SizedBox(height: 25),

                // Contenu pédagogique complet
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.7),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Section 1: Définition
                      _buildInfoCard(
                          title: '🔍 Qu\'est-ce qu\'un FVG ?',
                          content: 'Un Fair Value Gap est une zone de déséquilibre créée lorsque le prix évolue rapidement '
                              'en laissant un "gap" entre les bougies. C\'est comme une autoroute que les institutions '
                              'doivent obligatoirement combler pour rétablir l\'équilibre du marché.'
                      ),
                      const SizedBox(height: 20),

                      // Section 2: Identification
                      _buildInfoCard(
                          title: '📌 Comment l\'identifier ?',
                          content: 'Trois conditions essentielles :\n\n'
                              '1. Une séquence de trois bougies\n'
                              '2. Aucun chevauchement entre les mèches\n'
                              '3. Un mouvement directionnel clair\n\n'
                              '➡️ Le FVG se forme entre le haut de la mèche 1 et le bas de la mèche 2'
                      ),
                      const SizedBox(height: 20),

                      // Section 3: Stratégie de trading
                      _buildInfoCard(
                          title: '💎 Stratégie professionnelle',
                          content: 'La méthode en 4 étapes :\n\n'
                              '1. 🔎 Repérer le FVG sur le graphique\n'
                              '2. ✅ Vérifier sur le timeframe supérieur\n'
                              '3. 🎯 Attendre le retest avec confirmation\n'
                              '4. ⚡ Entrer en trade avec un ratio R:R > 1:2'
                      ),
                      const SizedBox(height: 20),

                      // Section 4: Bonnes pratiques
                      _buildInfoCard(
                          title: '🚨 Les pièges à éviter',
                          content: '- Ne pas trader les FVG isolés\n'
                              '- Toujours vérifier le contexte global\n'
                              '- Éviter les FVG en plein range\n'
                              '- Ne pas ignorer les niveaux de liquidité'
                      ),
                      const SizedBox(height: 20),

                      // Section 5: Exemple pratique
                      _buildInfoCard(
                          title: '📈 Cas pratique type',
                          content: '1. Le prix forme un FVG après une liquidation de stops\n'
                              '2. Il revient combler le FVG avec une accumulation\n'
                              '3. On observe une absorption des ordres\n'
                              '4. Le prix repart en tendance initiale'
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 30),
                // Zone vidéo
                const Text(
                  '🎬 Masterclass FVG en vidéo :',
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
                  ),
                  child: Column(
                    children: [
                      const Text(
                        'TESTEZ VOTRE MAÎTRISE DES FVG',
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
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 30,
                            vertical: 12,
                          ),
                        ),
                        onPressed: () {},
                        child: const Text(
                          'Démarrer le quiz',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
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

  // Widget réutilisable pour les cartes d'information
  Widget _buildInfoCard({required String title, required String content}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.grey[900]!.withOpacity(0.5),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.deepOrange),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Colors.deepOrange,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            content,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}