import 'dart:async';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/leaderboard_service.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _pulseController;
  late AnimationController _laserController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _pulseAnimation;
  String _statusText = "🔶 Scanning Market...";

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    _initializeApp();
  }

  void _setupAnimations() {
    // 🌟 Fade général
    _fadeController =
        AnimationController(vsync: this, duration: const Duration(seconds: 2));
    _fadeAnimation =
        Tween<double>(begin: 0.0, end: 1.0).animate(_fadeController);
    _fadeController.forward();

    // 💫 Pulsation du logo
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
    _pulseAnimation =
        Tween<double>(begin: 0.9, end: 1.15).animate(CurvedAnimation(
          parent: _pulseController,
          curve: Curves.easeInOut,
        ));

    // ⚡ Animation du laser qui balaye le texte
    _laserController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat();
  }

  Future<void> _initializeApp() async {
    try {
      await Firebase.initializeApp();
      await Hive.initFlutter();
      await Hive.openBox('trades_data');
      await Hive.openBox('wallet_data');
      await Hive.openBox('quiz_data');

      final prefs = await SharedPreferences.getInstance();
      final isSubscribed =
          prefs.getBool('sniperbot_abonnement_actif') ?? false;
      final dateStr = prefs.getString('abonnement_date');
      if (isSubscribed && dateStr != null) {
        final date = DateTime.tryParse(dateStr);
        final expiration = date?.add(const Duration(days: 30));
        if (expiration != null && DateTime.now().isAfter(expiration)) {
          await prefs.setBool('sniperbot_abonnement_actif', false);
          await prefs.remove('abonnement_date');
        }
      }

      await registerUserInLeaderboard();

      // 💥 Petit délai pour profiter de l’animation
      await Future.delayed(const Duration(seconds: 2));
      if (mounted) Navigator.pushReplacementNamed(context, "/home");
    } catch (e, stack) {
      debugPrint("❌ Erreur au démarrage: $e\n$stack");
      setState(() => _statusText = "Erreur: $e");
    }
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _pulseController.dispose();
    _laserController.dispose();
    super.dispose();
  }

  Widget _safeLottie(String path) {
    try {
      return Lottie.asset(path, fit: BoxFit.cover, repeat: true);
    } catch (_) {
      return Container(color: Colors.black);
    }
  }

  /// 🌈 Texte avec effet laser
  Widget _laserText(String text) {
    return AnimatedBuilder(
      animation: _laserController,
      builder: (context, child) {
        // position du balayage
        final gradientPosition =
            (_laserController.value * 2) % 2; // 0 → 1 → 0 (loop)
        return ShaderMask(
          shaderCallback: (Rect bounds) {
            return LinearGradient(
              begin: Alignment(-1, 0),
              end: Alignment(1, 0),
              colors: [
                Colors.orange.withOpacity(0.2),
                Colors.orangeAccent,
                Colors.yellowAccent.withOpacity(0.6),
                Colors.orange.withOpacity(0.2),
              ],
              stops: [
                gradientPosition - 0.3,
                gradientPosition,
                gradientPosition + 0.3,
                gradientPosition + 0.6,
              ],
            ).createShader(bounds);
          },
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.2,
              fontStyle: FontStyle.italic,
              color: Colors.white,
              shadows: [
                Shadow(
                  blurRadius: 10,
                  color: Colors.orangeAccent,
                  offset: Offset(0, 0),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        fit: StackFit.expand,
        children: [
          // 🔥 Fond animé Lottie (bougies)
          _safeLottie("assets/animations/candles.json"),

          // 💎 Logo central avec halo pulsant
          Center(
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: ScaleTransition(
                scale: _pulseAnimation,
                child: Container(
                  width: 220,
                  height: 220,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.orangeAccent,
                        blurRadius: 60,
                        spreadRadius: 10,
                      ),
                    ],
                  ),
                  child: ClipOval(
                    child: Image.asset(
                      "assets/images/icon.png",
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ),
          ),

          // 🌈 Texte laser + barre de progression
          Positioned(
            bottom: 80,
            left: 0,
            right: 0,
            child: Column(
              children: [
                _laserText(_statusText),
                const SizedBox(height: 20),
                const CircularProgressIndicator(
                  color: Colors.orangeAccent,
                  strokeWidth: 2,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
