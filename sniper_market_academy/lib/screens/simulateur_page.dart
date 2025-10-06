import 'package:flutter/material.dart';

class SimulateurPage extends StatefulWidget {
  final int chartNumber;

  const SimulateurPage({Key? key, required this.chartNumber}) : super(key: key);

  @override
  State<SimulateurPage> createState() => _SimulateurPageState();
}

class _SimulateurPageState extends State<SimulateurPage> {
  final TextEditingController entryController = TextEditingController();
  final TextEditingController slController = TextEditingController();
  final TextEditingController tpController = TextEditingController();
  final TextEditingController contextController = TextEditingController();

  String feedbackMessage = '';
  bool submitted = false;

  void evaluateTrade() {
    final entry = double.tryParse(entryController.text);
    final sl = double.tryParse(slController.text);
    final tp = double.tryParse(tpController.text);

    if (entry == null || sl == null || tp == null) {
      setState(() {
        feedbackMessage = '❌ Veuillez entrer des valeurs valides.';
        submitted = true;
      });
      return;
    }

    if ((entry > sl) && (tp > entry)) {
      feedbackMessage = '✅ Setup logique : Entrée > SL et TP > entrée.';
    } else {
      feedbackMessage = '❌ Setup incohérent : vérifie SL/TP par rapport à ton entrée.';
    }

    setState(() {
      submitted = true;
    });
  }

  @override
  void dispose() {
    entryController.dispose();
    slController.dispose();
    tpController.dispose();
    contextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final imagePath = 'assets/images/chart_${widget.chartNumber}.png';

    return Scaffold(
      appBar: AppBar(
        title: Text('Simulateur #${widget.chartNumber}'),
        backgroundColor: Colors.black87,
      ),
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Image.asset(imagePath),
            const SizedBox(height: 16),
            TextField(
              controller: entryController,
              keyboardType: TextInputType.number,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                labelText: 'Entrée',
                labelStyle: TextStyle(color: Colors.white),
                enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white54)),
                focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.blueAccent)),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: slController,
              keyboardType: TextInputType.number,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                labelText: 'Stop Loss',
                labelStyle: TextStyle(color: Colors.white),
                enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white54)),
                focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.blueAccent)),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: tpController,
              keyboardType: TextInputType.number,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                labelText: 'Take Profit',
                labelStyle: TextStyle(color: Colors.white),
                enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white54)),
                focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.blueAccent)),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: contextController,
              maxLines: 2,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                labelText: 'Contexte (BOS, OB, FVG, etc)',
                labelStyle: TextStyle(color: Colors.white),
                enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white54)),
                focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.blueAccent)),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: evaluateTrade,
              child: const Text('Soumettre'),
            ),
            const SizedBox(height: 20),
            if (submitted)
              Text(
                feedbackMessage,
                style: TextStyle(
                  color: feedbackMessage.startsWith('✅') ? Colors.green : Colors.redAccent,
                  fontSize: 16,
                ),
              )
          ],
        ),
      ),
    );
  }
}
