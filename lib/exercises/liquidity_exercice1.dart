import 'package:flutter/material.dart';

class LiquidityExercice1 extends StatefulWidget {
  const LiquidityExercice1({Key? key}) : super(key: key);

  @override
  State<LiquidityExercice1> createState() => _LiquidityExercice1State();
}

class _LiquidityExercice1State extends State<LiquidityExercice1> {
  int selectedAnswer = -1;
  bool showResult = false;

  final int correctAnswerIndex = 0;
  final List<String> answers = [
    'Une mèche qui dépasse les précédents plus hauts/bas puis se renverse',
    'Un range régulier avec très peu de volume',
    'Un order block suivi d’une continuation directe',
    'Un double top/double bottom confirmé',
  ];

  void validateAnswer() {
    setState(() {
      showResult = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('💧 Liquidité - Exercice'),
        backgroundColor: Colors.deepOrange,
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/menu_background.png'),
            fit: BoxFit.cover,
          ),
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Text(
              'Quelle structure montre une prise de liquidité (liquidity grab) ?',
              style: TextStyle(fontSize: 18, color: Colors.white),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Image.asset('assets/images/liquidity_exercise1_graph.png'),
            const SizedBox(height: 24),
            ...List.generate(answers.length, (index) {
              final isSelected = selectedAnswer == index;
              return Container(
                margin: const EdgeInsets.symmetric(vertical: 6),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isSelected ? Colors.lightGreen : Colors.white54,
                    width: 2,
                  ),
                  color: isSelected ? Colors.white10 : Colors.black38,
                ),
                child: ListTile(
                  title: Text(
                    answers[index],
                    style: const TextStyle(color: Colors.white),
                  ),
                  onTap: showResult
                      ? null
                      : () {
                    setState(() {
                      selectedAnswer = index;
                    });
                  },
                ),
              );
            }),
            const SizedBox(height: 20),
            if (!showResult)
              ElevatedButton(
                onPressed: selectedAnswer != -1 ? validateAnswer : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orangeAccent,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                ),
                child: const Text('Valider'),
              ),
            if (showResult)
              Padding(
                padding: const EdgeInsets.only(top: 16),
                child: Text(
                  selectedAnswer == correctAnswerIndex
                      ? '✅ Bravo ! C’est bien une chasse de liquidité par mèche au-delà des extrêmes.'
                      : '❌ Mauvaise réponse. Regarde les mèches qui dépassent les hauts/bas avant de se retourner.',
                  style: TextStyle(
                    color: selectedAnswer == correctAnswerIndex ? Colors.green : Colors.redAccent,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
