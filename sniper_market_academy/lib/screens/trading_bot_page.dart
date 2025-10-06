import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:audioplayers/audioplayers.dart';
import '../services/sniperbot_client.dart';

class TradingBotPage extends StatefulWidget {
  const TradingBotPage({Key? key}) : super(key: key);

  @override
  State<TradingBotPage> createState() => _TradingBotPageState();
}

class _TradingBotPageState extends State<TradingBotPage> {
  File? selectedImage;
  Map<String, dynamic>? result;
  bool isLoading = false;
  String? errorMessage;
  bool isSubscribed = false;

  int uploadCount = 0;
  DateTime? abonnementDate;
  final ImagePicker picker = ImagePicker();
  final AudioPlayer audioPlayer = AudioPlayer();

  @override
  void initState() {
    super.initState();
    _checkSubscriptionStatus();
    _loadAbonnementInfos();
  }

  Future<void> _checkSubscriptionStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final savedDate = prefs.getString('abonnement_date');
    bool actif = prefs.getBool('sniperbot_abonnement_actif') ?? false;

    if (savedDate != null && actif) {
      final abonnementDateParsed = DateTime.tryParse(savedDate);
      if (abonnementDateParsed != null) {
        final expiration = abonnementDateParsed.add(const Duration(days: 30));
        if (DateTime.now().isAfter(expiration)) {
          actif = false;
          await prefs.setBool('sniperbot_abonnement_actif', false);
          await prefs.setInt('upload_count', 0);
          await prefs.remove('abonnement_date');
        }
      }
    }

    setState(() {
      isSubscribed = actif;
    });
  }

  Future<void> _loadAbonnementInfos() async {
    final prefs = await SharedPreferences.getInstance();
    final savedDate = prefs.getString('abonnement_date');
    final count = prefs.getInt('upload_count') ?? 0;

    setState(() {
      abonnementDate = savedDate != null ? DateTime.tryParse(savedDate) : null;
      uploadCount = count;
    });
  }

  Future<void> _saveAbonnementInfos() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('upload_count', uploadCount);
    if (abonnementDate != null) {
      await prefs.setString('abonnement_date', abonnementDate!.toIso8601String());
    }
  }

  bool _isWithinSubscriptionPeriod() {
    if (abonnementDate == null) return false;
    final expirationDate = abonnementDate!.add(const Duration(days: 30));
    return DateTime.now().isBefore(expirationDate);
  }

  bool _canUpload() {
    return _isWithinSubscriptionPeriod() && uploadCount < 100;
  }

  Future<void> pickImage() async {
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        selectedImage = File(image.path);
        result = null;
        errorMessage = null;
      });
    }
  }

  Future<void> analyzeImage() async {
    if (selectedImage == null) return;

    if (!_canUpload()) {
      setState(() {
        errorMessage = '🚫 Limite de 100 images atteinte ou abonnement expiré.';
      });
      return;
    }

    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      await audioPlayer.play(AssetSource('assets/audio/sniper_scan_effect.mp3'));

      final response = await SniperBotClient.sendFileImage(selectedImage!);
      setState(() {
        result = response;
        isLoading = false;
        uploadCount++;
      });

      _saveAbonnementInfos();
    } catch (e) {
      setState(() {
        errorMessage = 'Erreur : $e';
        isLoading = false;
      });
    }
  }

  Widget buildResult() {
    if (errorMessage != null) {
      return Text(errorMessage!, style: const TextStyle(color: Colors.red));
    }
    if (result == null) return const SizedBox();
    return Card(
      margin: const EdgeInsets.only(top: 20),
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("📊 Direction : ${result!['direction'] ?? 'Non détecté'}"),
            Text("🎯 Entrée : ${result!['entry'] ?? 'Non disponible'}"),
            Text("🛑 Stop Loss : ${result!['stop_loss'] ?? 'Non disponible'}"),
            Text("🎯 Take Profit : ${result!['take_profit'] ?? 'Non disponible'}"),
            Text("✅ Confiance : ${result!['confiance'] ?? 'Non précisé'}"),
            Text("📝 Commentaire : ${result!['commentaire'] ?? 'Aucun'}"),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (!isSubscribed) {
      return Scaffold(
        appBar: AppBar(title: const Text("SniperBot IA - Verrouillé")),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.lock_outline, size: 80, color: Colors.grey),
              const SizedBox(height: 20),
              const Text("Accès réservé aux abonnés SniperBot",
                  style: TextStyle(fontSize: 16, color: Colors.white70)),
              const SizedBox(height: 10),
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.pushNamed(context, '/subscription');
                },
                icon: const Icon(Icons.lock_open),
                label: const Text("Débloquer pour 14,99€/mois"),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text("SniperBot IA – Uploader une image")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Text("📷 Images utilisées : $uploadCount / 100",
                style: const TextStyle(color: Colors.white70)),
            ElevatedButton.icon(
              onPressed: pickImage,
              icon: const Icon(Icons.image),
              label: const Text("📁 Choisir une image"),
            ),
            const SizedBox(height: 20),
            if (selectedImage != null)
              Column(
                children: [
                  Image.file(selectedImage!, height: 200),
                  const SizedBox(height: 20),
                  ElevatedButton.icon(
                    onPressed: isLoading ? null : analyzeImage,
                    icon: const Icon(Icons.radar),
                    label: isLoading
                        ? const Text("🔍 Analyse en cours...")
                        : const Text("📡 Scanner avec IA"),
                  ),
                ],
              ),
            if (isLoading)
              const Padding(
                padding: EdgeInsets.all(20),
                child: CircularProgressIndicator(),
              ),
            buildResult(),
          ],
        ),
      ),
    );
  }
}
