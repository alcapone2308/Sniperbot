import 'package:flutter/material.dart';

class TradingBotPage extends StatelessWidget {
  const TradingBotPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("SniperBot IA"),
        backgroundColor: Colors.deepOrange,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(Icons.construction, size: 80, color: Colors.orangeAccent),
            SizedBox(height: 20),
            Text(
              "🚧 SniperBot IA sera bientôt disponible",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18, color: Colors.white70),
            ),
            SizedBox(height: 10),
            Text(
              "Disponible dans une future mise à jour 🔥",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: Colors.white54),
            ),
          ],
        ),
      ),
    );
  }
}
