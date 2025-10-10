import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'modules_page.dart';
import 'exercises_page.dart';
import 'progression_page.dart';
import 'glossary_page.dart';
import 'edit_profile_page.dart';
import 'economic_announcements_page.dart';
import 'prop_firm_info_page.dart';
import 'leaderboard_page.dart';
import 'trade_simulator_page.dart'; // ✅ Simulateur ajouté
import '../widgets/economic_banner.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _username = 'Nouveau Trader';
  String _level = 'Débutant';
  int _modulesCompleted = 0;
  int _minutesFocused = 0;
  String? _profileImagePath;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _username = prefs.getString('username') ?? 'Nouveau Trader';
      _level = prefs.getString('level') ?? 'Débutant';
      _modulesCompleted = prefs.getInt('modulesCompleted') ?? 0;
      _minutesFocused = prefs.getInt('minutesFocused') ?? 0;
      _profileImagePath = prefs.getString('profileImage');
    });
  }

  void _showComingSoonDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('SniperBot — Bientôt disponible'),
        content: const Text(
          'Merci pour ton intérêt !\n\n'
              'Le SniperBot sera bientôt disponible sur toutes les plateformes. '
              'Nous travaillons à son intégration complète avec les achats intégrés officiels (Google & Apple). '
              'Reviens bientôt pour l’activation !',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: _buildDrawer(context),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/menu_background.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                const EconomicScrollingBanner(),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 20),
                        Row(
                          children: [
                            Container(
                              width: 60,
                              height: 60,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.deepOrange,
                              ),
                              child: const Icon(Icons.person, color: Colors.white, size: 32),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Bienvenue, ${_username.isEmpty ? "Nouveau Trader" : _username}',
                                    style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                  Text(
                                    'Niveau : $_level',
                                    style: const TextStyle(
                                      fontSize: 16,
                                      color: Colors.white70,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  const Text(
                                    'Ta mission : devenir un sniper du marché',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.orangeAccent,
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                        const SizedBox(height: 20),
                        const Text(
                          '"Le marché récompense la patience, pas la précipitation."',
                          style: TextStyle(
                            fontStyle: FontStyle.italic,
                            fontSize: 14,
                            color: Colors.white70,
                          ),
                        ),
                        const SizedBox(height: 30),

                        // ✅ Boutons principaux (SniperBot supprimé ici)
                        _buildMainButton(Icons.menu_book, 'Modules SMC', const ModulesPage()),
                        _buildMainButton(Icons.bar_chart, 'Exercices', const ExercisesPage()),
                        _buildMainButton(Icons.rocket_launch, 'Progression', const ProgressionPage()),
                        _buildMainButton(Icons.trending_up, 'Simulateur de Trade', const TradeSimulatorPage()),
                        _buildMainButton(Icons.attach_money, 'Annonce Économique', const EconomicAnnouncementsPage()),
                        _buildMainButton(Icons.leaderboard, 'Classement', const LeaderboardPage()),

                        const SizedBox(height: 20),
                        Center(
                          child: Text(
                            '📍 Module $_modulesCompleted sur 7 complété  |  ⏱️ $_minutesFocused minutes de focus total',
                            style: const TextStyle(color: Colors.white70, fontSize: 13),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 30,
            left: 20,
            right: 20,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildFloatingButton(Icons.menu_book, 'Glossaire SMC', const GlossaryPage()),
                _buildFloatingButton(Icons.settings, 'Paramètres', const EditProfilePage(), reload: true),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawer(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.black,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(color: Colors.deepOrange),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Sniper Market Academy',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'Bienvenue, ${_username.isEmpty ? "Nouveau Trader" : _username}',
                  style: const TextStyle(color: Colors.white70),
                ),
              ],
            ),
          ),
          _drawerItem(Icons.menu_book, 'Modules SMC', const ModulesPage()),
          _drawerItem(Icons.bar_chart, 'Exercices', const ExercisesPage()),
          _drawerItem(Icons.rocket_launch, 'Progression', const ProgressionPage()),
          _drawerItem(Icons.trending_up, 'Simulateur de Trade', const TradeSimulatorPage()),
          _sniperBotDrawerItem(), // ✅ On le garde ici
          _drawerItem(Icons.attach_money, 'Annonce Éco', const EconomicAnnouncementsPage()),
          _drawerItem(Icons.leaderboard, 'Classement', const LeaderboardPage()),
          _drawerItem(Icons.menu_book_outlined, 'Glossaire SMC', const GlossaryPage()),
          _drawerItem(Icons.settings, 'Paramètres', const EditProfilePage(), reload: true),
          const Divider(color: Colors.white24),
          ListTile(
            tileColor: Colors.deepOrangeAccent,
            leading: const Icon(Icons.military_tech, color: Colors.white),
            title: const Text(
              '🔥 Acheter une Prop Firm',
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
            subtitle: const Text(
              'Débloque ton capital dès aujourd’hui',
              style: TextStyle(color: Colors.white70, fontSize: 12),
            ),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => const PropFirmInfoPage()));
            },
          ),
        ],
      ),
    );
  }

  Widget _sniperBotDrawerItem() {
    return ListTile(
      leading: const Icon(Icons.lock_outline, color: Colors.white70),
      title: const Text('SniperBot IA (bientôt disponible)', style: TextStyle(color: Colors.white70)),
      subtitle: const Text(
        'Disponible prochainement sur Android et iOS',
        style: TextStyle(color: Colors.white54, fontSize: 12),
      ),
      onTap: _showComingSoonDialog,
    );
  }

  Widget _drawerItem(IconData icon, String label, Widget page, {bool reload = false}) {
    return ListTile(
      leading: Icon(icon, color: Colors.white),
      title: Text(label, style: const TextStyle(color: Colors.white)),
      onTap: () async {
        await Navigator.push(context, MaterialPageRoute(builder: (_) => page));
        if (reload) _loadUserData();
      },
    );
  }

  Widget _buildMainButton(IconData icon, String label, Widget targetPage) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.deepOrange,
          minimumSize: const Size(double.infinity, 55),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        ),
        icon: Icon(icon, size: 24, color: Colors.white),
        label: Text(label, style: const TextStyle(fontSize: 18, color: Colors.white)),
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (_) => targetPage));
        },
      ),
    );
  }

  Widget _buildFloatingButton(IconData icon, String tooltip, Widget targetPage, {bool reload = false}) {
    return FloatingActionButton.extended(
      heroTag: tooltip,
      backgroundColor: Colors.black87,
      onPressed: () async {
        await Navigator.push(context, MaterialPageRoute(builder: (_) => targetPage));
        if (reload) _loadUserData();
      },
      icon: Icon(icon, color: Colors.white),
      label: Text(tooltip, style: const TextStyle(color: Colors.white)),
    );
  }
}
