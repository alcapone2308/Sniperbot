import 'package:flutter/material.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

class MarketStructure extends StatefulWidget {
  const MarketStructure({super.key});

  @override
  State<MarketStructure> createState() => _MarketStructureState();
}

class _MarketStructureState extends State<MarketStructure> {
  late YoutubePlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = YoutubePlayerController(
      params: const YoutubePlayerParams(
        showControls: true,
        showFullscreenButton: true,
      ),
    )..loadVideoById(videoId: 'wyaS8GOrlzw'); // 🎥 ID YouTube
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
            title: const Text("📊 Structure du Marché"),
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
                    "📊 Qu'est-ce que la Structure du Marché ?",
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
                      image: AssetImage('assets/images/market_structure_explained.png'),
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
                      // Définition de la structure du marché
                      _buildInfoCard(
                          title: "🔍 Qu'est-ce que la structure du marché ?",
                          content: "La structure du marché fait référence à la séquence des sommets (highs) et des creux (lows) "
                              "qui se forment sur un graphique. Elle est essentielle pour comprendre la direction "
                              "générale du marché et pour prendre des décisions de trading éclairées."
                      ),
                      const SizedBox(height: 20),

                      // Marché haussier
                      _buildInfoCard(
                          title: "📈 Marché Haussier",
                          content: "Un marché haussier est caractérisé par des sommets et des creux de plus en plus hauts. "
                              "Cela indique que les acheteurs prennent le contrôle et que la tendance est à la hausse. "
                              "Les traders cherchent souvent à acheter dans cette phase."
                      ),
                      const SizedBox(height: 20),

                      // Marché baissier
                      _buildInfoCard(
                          title: "📉 Marché Baissier",
                          content: "À l'inverse, un marché baissier montre des sommets et des creux de plus en plus bas. "
                              "Cela signifie que les vendeurs dominent et que la tendance est à la baisse. "
                              "Les traders peuvent chercher à vendre ou à se protéger dans cette phase."
                      ),
                      const SizedBox(height: 20),

                      // Importance de la structure du marché
                      _buildInfoCard(
                          title: "💡 Importance de la structure du marché",
                          content: "Comprendre la structure du marché est crucial pour les traders car elle permet d'identifier "
                              "les points d'entrée et de sortie potentiels. En analysant les sommets et les creux, "
                              "les traders peuvent mieux anticiper les mouvements futurs du marché."
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
                        'TESTEZ VOTRE CONNAISSANCE DE LA STRUCTURE DU MARCHÉ',
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