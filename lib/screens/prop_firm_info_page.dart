import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class PropFirmInfoPage extends StatelessWidget {
  const PropFirmInfoPage({super.key});

  Future<void> _launchURL() async {
    final Uri url = Uri.parse("https://client-area.smartraderfunds.com/buy-challenge/?referral=3e3c95e2");
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      throw Exception('Impossible d’ouvrir $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Prop Firm"),
        backgroundColor: Colors.deepOrange,
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/menu_background.png'),
            fit: BoxFit.cover,
          ),
        ),
        padding: const EdgeInsets.all(20),
        child: ListView(
          children: [
            const Text(
              "🔥 Qu'est-ce qu'une Prop Firm ?",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 20),

            const Text.rich(
              TextSpan(
                style: TextStyle(color: Colors.white70, fontSize: 16, height: 1.5),
                children: [
                  TextSpan(
                    text: "💡 Une Prop Firm (ou entreprise de trading propriétaire) te permet de ",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextSpan(
                    text: "trader avec leur capital, sans risquer ton propre argent",
                    style: TextStyle(fontWeight: FontWeight.bold, color: Colors.orangeAccent),
                  ),
                  TextSpan(
                    text: ". Pour cela, tu dois réussir un test de compétence qui prouve que tu sais gérer le risque et trader avec discipline.\n\n",
                  ),
                  TextSpan(
                    text: "✅ Si tu réussis le test, tu reçois un compte financé (souvent entre 10 000 € et 200 000 €) et tu gardes jusqu’à ",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextSpan(
                    text: "90% des profits générés.",
                    style: TextStyle(fontWeight: FontWeight.bold, color: Colors.orangeAccent),
                  ),
                  TextSpan(
                    text: "\n\n🚀 C’est le moyen idéal de vivre du trading sans avoir besoin d’un gros capital de départ.",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 40),

            const Text(
              "🎯 Comment ça fonctionne ?",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.orangeAccent,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              "• Tu passes un test (souvent 1 ou 2 phases).\n"
                  "• Tu dois respecter certaines règles : drawdown, objectif de profit, etc.\n"
                  "• Si tu réussis, tu reçois un compte financé (jusqu’à 100 000€ ou plus).\n"
                  "• Tu peux ensuite toucher entre 75 % et 90 % des gains générés.",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white70,
                height: 1.5,
              ),
            ),

            const SizedBox(height: 30),
            const Text(
              "✅ Avantages",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.orangeAccent,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              "• Tu n’as pas besoin d’un gros capital personnel.\n"
                  "• Tu limites tes risques : en cas de perte, c’est la prop firm qui assume.\n"
                  "• Tu peux gagner de vrais revenus si tu trades bien.\n"
                  "• Certaines proposent des remises ou remboursements après réussite.",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white70,
                height: 1.5,
              ),
            ),

            const SizedBox(height: 40),

            Center(
              child: ElevatedButton.icon(
                onPressed: _launchURL,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepOrange,
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                ),
                icon: const Icon(Icons.open_in_browser, color: Colors.white),
                label: const Text(
                  "🔥 Acheter une Prop Firm",
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
