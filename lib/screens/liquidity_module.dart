import 'package:flutter/material.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

class LiquidityModule extends StatefulWidget {
  const LiquidityModule({super.key});

  @override
  State<LiquidityModule> createState() => _LiquidityModuleState();
}

class _LiquidityModuleState extends State<LiquidityModule> {
  late YoutubePlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = YoutubePlayerController(
      params: const YoutubePlayerParams(
        showControls: true,
        showFullscreenButton: true,
      ),
    )..loadVideoById(videoId: 'AfxoAIhhz20'); // ID YouTube
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
            title: const Text("💧 Liquidité - Zones d'intérêt"),
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
                // Titre principal
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.deepOrange, width: 2),
                  ),
                  child: const Text(
                    "💧 Qu'est-ce que la liquidité ?",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Image explicative
                Card(
                  elevation: 10,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: const Image(
                      image: AssetImage('assets/images/liquidity_module_explained.png'),
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Contenu pédagogique
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.7),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Définition de la liquidité
                      _buildInfoCard(
                          title: "🔍 Qu'est-ce que la liquidité ?",
                          content: "La liquidité fait référence à la capacité d'un actif à être acheté ou vendu sur le marché sans "
                              "affecter son prix. Dans le trading, une liquidité élevée signifie qu'il y a beaucoup d'acheteurs "
                              "et de vendeurs, ce qui permet des transactions rapides et efficaces."
                      ),
                      const SizedBox(height: 20),

                      // Zones de liquidité
                      _buildInfoCard(
                          title: "📌 Zones de liquidité",
                          content: "Les zones de liquidité sont des niveaux de prix où les traders placent généralement leurs "
                              "ordres stop-loss (SL). Ces zones se trouvent souvent :\n"
                              "- Au-dessus d'un sommet (high)\n"
                              "- En dessous d'un creux (low)\n\n"
                              "Ces niveaux deviennent des cibles pour les institutions qui cherchent à piéger les traders retail."
                      ),
                      const SizedBox(height: 20),

                      // Importance des zones de liquidité
                      _buildInfoCard(
                          title: "💡 Pourquoi sont-elles importantes ?",
                          content: "Comprendre les zones de liquidité est crucial pour les traders car elles peuvent indiquer "
                              "des points d'entrée et de sortie potentiels. Les institutions utilisent ces zones pour "
                              "accumuler des positions avant de faire bouger le marché."
                      ),
                      const SizedBox(height: 20),

                      // Stratégies de trading
                      _buildInfoCard(
                          title: "🎯 Stratégies de trading",
                          content: "1. **Repérer les zones de liquidité** : Identifiez les niveaux où les SL sont souvent placés.\n"
                              "2. **Attendre le retest** : Après une cassure, attendez que le prix revienne à ces niveaux.\n"
                              "3. **Entrer en position** : Utilisez des confirmations techniques pour entrer dans le trade."
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 30),
                // Zone vidéo
                const Text(
                  '🎬 Cas pratiques en vidéo :',
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
                        'TESTEZ VOTRE CONNAISSANCE DE LA LIQUIDITÉ',
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