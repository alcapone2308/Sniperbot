import 'package:flutter/material.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

class BOSModule extends StatefulWidget {
  const BOSModule({super.key});

  @override
  State<BOSModule> createState() => _BOSModuleState();
}

class _BOSModuleState extends State<BOSModule> {
  late YoutubePlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = YoutubePlayerController(
      params: const YoutubePlayerParams(
        showControls: true,
        showFullscreenButton: true,
      ),
    )..loadVideoById(videoId: 'uYZQrQqsMvI');
  }

  @override
  void dispose() {
    _controller.close();
    super.dispose();
  }

  Widget _buildInfoCard({required String title, required String content}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      margin: const EdgeInsets.only(bottom: 15),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.6),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.deepOrange, width: 1.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Colors.deepOrange,
              fontSize: 17,
              fontWeight: FontWeight.bold,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            content,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 15,
              height: 1.6,
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
            title: const Text('📊 Break of Structure (BOS)'),
            backgroundColor: Colors.deepOrange,
            centerTitle: true,
          ),
          body: Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/menu_background.png'),
                fit: BoxFit.cover,
              ),
            ),
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                // En-tête avec dégradé identique
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFFFF7043), Color(0xFFFF5722)],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.deepOrange.withOpacity(0.3),
                        blurRadius: 8,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: const Column(
                    children: [
                      Text(
                        'BREAK OF STRUCTURE',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Le tournant décisif du marché',
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.white,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 25),

                // Image avec effets identiques
                Card(
                  elevation: 8,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  margin: const EdgeInsets.symmetric(horizontal: 10),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(14),
                    child: Image.asset(
                      'assets/images/bos_module_explained.png',
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                const SizedBox(height: 25),

                // Contenu pédagogique organisé
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildInfoCard(
                        title: '🎯 L\'Essence du BOS',
                        content: 'Le Break of Structure (BOS) marque le moment où le prix franchit un niveau clé, '
                            'indiquant un changement de l\'équilibre entre acheteurs et vendeurs. C\'est '
                            'le signal que les institutions modifient leur stratégie.',
                      ),

                      _buildInfoCard(
                        title: '🔍 Les 2 Types Cruciaux',
                        content: '• BOS Haussier (✅) : Franchissement d\'un précédent haut\n'
                            '• BOS Baissier (⚠️) : Rupture d\'un précédent bas\n\n'
                            'Chacun révèle une prise de contrôle différente du marché.',
                      ),

                      _buildInfoCard(
                        title: '💎 Pourquoi ça marche',
                        content: 'Les BOS sont fiables car :\n'
                            '- Ils montrent l\'échec d\'un groupe de traders\n'
                            '- Ils créent de nouvelles liquidités\n'
                            '- Ils attirent les ordres stop des contre-tendances',
                      ),

                      _buildInfoCard(
                        title: '🚀 Stratégie Pro en 3 Étapes',
                        content: '1️⃣ Repérer la structure actuelle\n'
                            '2️⃣ Attendre la cassure claire avec volume\n'
                            '3️⃣ Entrer sur retest avec un ratio R:R > 1:2\n\n'
                            '+ Confirmation idéale : convergence avec FVG/OB',
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 30),

                // Zone vidéo standardisée
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    '🎯 Démonstration en Trading Réel',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 10),
                  child: player,
                ),
                const SizedBox(height: 30),

                // Bouton d'action identique
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 40),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFFFF7043), Color(0xFFFF5722)],
                    ),
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.deepOrange.withOpacity(0.3),
                        blurRadius: 8,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      const Text(
                        'PRÊT À APPLIQUER LE BOS ?',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 12),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 30),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          elevation: 3,
                        ),
                        onPressed: () {},
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.play_circle_outline),
                            SizedBox(width: 8),
                            Text('Lancer l\'exercice pratique', style: TextStyle(fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 30),
              ],
            ),
          ),
        );
      },
    );
  }
}