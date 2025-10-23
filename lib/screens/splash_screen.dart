import 'dart:async';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;
  bool _assetsLoaded = false;

  @override
  void initState() {
    super.initState();

    _initAnimations();
    _preloadAssets().then((_) {
      // Délai de 3s avant de passer à la page Home
      Timer(const Duration(seconds: 3), () {
        if (mounted) {
          Navigator.pushReplacementNamed(context, "/home");
        }
      });
    });
  }

  /// ⚙️ Précharge les assets pour éviter écran blanc sur iOS
  Future<void> _preloadAssets() async {
    try {
      await precacheImage(const AssetImage("assets/images/icon.png"), context);
      await AssetLottie('assets/animations/candles.json');
      setState(() => _assetsLoaded = true);
    } catch (e) {
      debugPrint("⚠️ Erreur de préchargement assets: $e");
    }
  }

  /// 🔄 Initialise les animations
  void _initAnimations() {
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    _scaleAnimation = Tween<double>(begin: 0.7, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutBack),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  /// 🧩 Widget de fallback si les assets échouent
  Widget _safeLottie(String path) {
    try {
      return Lottie.asset(path, fit: BoxFit.cover);
    } catch (e) {
      debugPrint("⚠️ Lottie asset introuvable: $path");
      return const SizedBox();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        fit: StackFit.expand,
        children: [
          // 🔥 Fond animé (Lottie)
          if (_assetsLoaded)
            _safeLottie("assets/animations/candles.json")
          else
            Container(color: Colors.black),

          // 🎯 Logo central animé
          Center(
            child: ScaleTransition(
              scale: _scaleAnimation,
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: Image.asset(
                  "assets/images/icon.png",
                  width: 180,
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),

          // 💬 Texte de chargement
          const Positioned(
            bottom: 40,
            left: 0,
            right: 0,
            child: Text(
              "Chargement de Sniper Market Academy...",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white70,
                fontSize: 14,
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
