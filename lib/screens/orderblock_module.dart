import 'package:flutter/material.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

class OrderBlockModule extends StatefulWidget {
  const OrderBlockModule({super.key});

  @override
  State<OrderBlockModule> createState() => _OrderBlockModuleState();
}

class _OrderBlockModuleState extends State<OrderBlockModule> {
  late YoutubePlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = YoutubePlayerController(
      params: const YoutubePlayerParams(
        showControls: true,
        showFullscreenButton: true,
      ),
    )..loadVideoById(videoId: 'F9qrl96gh-c'); // ID YouTube
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
            title: const Text("🟦 Order Block - Bloc d’Ordre"),
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
                    "🟦 Qu'est-ce qu'un Order Block ?",
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
                      image: AssetImage('assets/images/orderblock_module_explained.png'),
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
                      // Définition de l'Order Block
                      _buildInfoCard(
                          title: "🔍 Qu'est-ce qu'un Order Block ?",
                          content: "Un Order Block est la dernière bougie haussière ou baissière avant une forte impulsion. "
                              "Il représente la zone où les institutions ont placé leurs ordres. "
                              "Ces zones sont cruciales car elles indiquent des niveaux de prix où le marché pourrait "
                              "revenir pour un retest."
                      ),
                      const SizedBox(height: 20),

                      // Importance des Order Blocks
                      _buildInfoCard(
                          title: "💡 Importance des Order Blocks",
                          content: "Les Order Blocks sont souvent utilisés comme points d'entrée stratégiques. "
                              "Lorsque le prix revient à ces zones, cela peut offrir des opportunités d'achat ou de vente. "
                              "Les traders surveillent ces niveaux pour anticiper les mouvements futurs du marché."
                      ),
                      const SizedBox(height: 20),

                      // Stratégies de trading avec Order Blocks
                      _buildInfoCard(
                          title: "🎯 Stratégies de Trading",
                          content: "1. **Identifier l'Order Block** : Recherchez la dernière bougie avant une forte impulsion.\n"
                              "2. **Attendre le retest** : Surveillez le retour du prix vers cette zone.\n"
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
                        'TESTEZ VOTRE CONNAISSANCE DES ORDER BLOCKS',
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