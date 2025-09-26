import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ActivatePromoPage extends StatefulWidget {
  const ActivatePromoPage({super.key});

  @override
  State<ActivatePromoPage> createState() => _ActivatePromoPageState();
}

class _ActivatePromoPageState extends State<ActivatePromoPage> {
  final TextEditingController _controller = TextEditingController();
  String? message;
  bool isLoading = false;

  Future<void> _checkPromoCode() async {
    final code = _controller.text.trim().toUpperCase();
    if (code.isEmpty) return;

    setState(() {
      isLoading = true;
      message = null;
    });

    try {
      final response = await http.post(
        Uri.parse('http://http://192.168.1.45:8000/check-code'),
        body: {'code': code},
      );

      if (response.statusCode == 200 && response.body.contains('VALID')) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setBool('sniperbot_abonnement_actif', true);
        await prefs.setString('abonnement_date', DateTime.now().toIso8601String());
        await prefs.setInt('upload_count', 0);

        setState(() => message = "✅ Code valide ! Abonnement activé.");
        Future.delayed(const Duration(seconds: 2), () {
          Navigator.pushReplacementNamed(context, '/sniperbot');
        });
      } else {
        setState(() => message = "❌ Code invalide ou déjà utilisé.");
      }
    } catch (e) {
      setState(() => message = "❌ Erreur serveur : $e");
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Activer avec un code promo")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const SizedBox(height: 40),
            const Text("🎁 Entre ton code promo",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            TextField(
              controller: _controller,
              decoration: const InputDecoration(
                labelText: "Code promo",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: isLoading ? null : _checkPromoCode,
              icon: const Icon(Icons.check_circle),
              label: const Text("Valider le code"),
            ),
            const SizedBox(height: 20),
            if (isLoading) const CircularProgressIndicator(),
            if (message != null)
              Text(message!,
                  style: TextStyle(
                    color: message!.startsWith("✅") ? Colors.green : Colors.red,
                  )),
          ],
        ),
      ),
    );
  }
}
