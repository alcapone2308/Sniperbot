import 'package:flutter/material.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

class OTEModule extends StatefulWidget {
  const OTEModule({super.key});

  @override
  State<OTEModule> createState() => _OTEModuleState();
}

class _OTEModuleState extends State<OTEModule> {
  late YoutubePlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = YoutubePlayerController(
      params: const YoutubePlayerParams(
        showControls: true,
        showFullscreenButton: true,
      ),
    )..loadVideoById(videoId: 'Ysx2KEvlvcI');
  }

  @override
  void dispose() {
    _controller.close();
    super.dispose();
  }

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

  @override
  Widget build(BuildContext context) {
    return YoutubePlayerScaffold(
      controller: _controller,
      builder: (context, player) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('🎯 OTE - Zone d\'Entrée Optimale'),
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
                        'OPTIMAL TRADE ENTRY (OTE)',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'La zone préférée des institutions',
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
                      'assets/images/ote_module_explained.png',
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                const SizedBox(height: 25),

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
                      _buildInfoCard(
                        title: '🔎 Cœur du concept OTE',
                        content: 'Zone précise entre 61.8% et 79% de retracement Fibonacci '
                            'où les Smart Money placent leurs ordres. Basé sur la théorie '
                            'que ces niveaux offrent le meilleur ratio risque/récompense.',
                      ),
                      const SizedBox(height: 20),

                      _buildInfoCard(
                        title: '📏 Comment mesurer l\'OTE',
                        content: '1. Identifier le swing haut et bas récents\n'
                            '2. Appliquer les niveaux Fibonacci\n'
                            '3. Marquer la zone 61.8-79%\n'
                            '4. Confirmer avec des volumes et structure',
                      ),
                      const SizedBox(height: 20),

                      _buildInfoCard(
                        title: '💎 Contextes gagnants',
                        content: '- Après un Break of Structure (BOS)\n'
                            '- Près d\'un niveau de liquidité clé\n'
                            '- Avec confluence de FVG/Order Block\n'
                            '- Sur timeframe H1+ pour plus de fiabilité',
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 30),
                const Text(
                  '🎯 Stratégie Professionnelle (3 étapes)',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 15),

                // Étapes stratégiques
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.deepOrange),
                  ),
                  child: const Column(
                    children: [
                      ListTile(
                        leading: Text('1️⃣', style: TextStyle(fontSize: 20)),
                        title: Text('Attendre le retracement vers OTE', style: TextStyle(color: Colors.white)),
                        subtitle: Text('Patience jusqu\'à ce que le prix touche la zone 61.8-79%', style: TextStyle(color: Colors.grey)),
                      ),
                      Divider(color: Colors.grey),
                      ListTile(
                        leading: Text('2️⃣', style: TextStyle(fontSize: 20)),
                        title: Text('Chercher une confirmation', style: TextStyle(color: Colors.white)),
                        subtitle: Text('Pinbar, absorption, divergence ou pattern de prix', style: TextStyle(color: Colors.grey)),
                      ),
                      Divider(color: Colors.grey),
                      ListTile(
                        leading: Text('3️⃣', style: TextStyle(fontSize: 20)),
                        title: Text('Entrée avec gestion de risque', style: TextStyle(color: Colors.white)),
                        subtitle: Text('SL derrière le dernier swing, TP minimal 1:2 RR', style: TextStyle(color: Colors.grey)),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 30),
                // Zone vidéo
                const Text(
                  '🎬 Exemples Réels en Trading',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                player,
                const SizedBox(height: 30),

                // Exerciseur pratique
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.deepOrange.shade700, Colors.orange.shade600],
                    ),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.deepOrange.withOpacity(0.3),
                        blurRadius: 10,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      const Text(
                        'PRÊT À VOUS EXERCER ?',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      ElevatedButton.icon(
                        icon: const Icon(Icons.play_arrow, color: Colors.deepOrange),
                        label: const Text(
                          'Lancer l\'exerciseur OTE',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.deepOrange,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 14,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        onPressed: () {},
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