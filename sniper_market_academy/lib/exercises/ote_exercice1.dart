import 'package:flutter/material.dart';

class OteExercice1 extends StatefulWidget {
  const OteExercice1({Key? key}) : super(key: key);

  @override
  State<OteExercice1> createState() => _OteExercice1State();
}

class _OteExercice1State extends State<OteExercice1> {
  int selectedAnswer = -1;
  bool showResult = false;

  final int correctAnswerIndex = 2;
  final List<String> answers = [
    'Entre 0% et 38.2%',
    'Entre 38.2% et 50%',
    'Entre 61.8% et 79% ',
    'Sous le niveau 100% de retracement',
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
        title: const Text('🎯 OTE - Exercice'),
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
              'Dans quelle zone se trouve une entrée optimale (OTE) après ce retracement ?',
              style: TextStyle(fontSize: 18, color: Colors.white),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset(
                'assets/images/ote_exercise1_graph.png',
                height: 200,
                fit: BoxFit.contain,
              ),
            ),
            const SizedBox(height: 24),
            Expanded(
              child: ListView(
                children: [
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
                            : () => setState(() {
                          selectedAnswer = index;
                        }),
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
                            ? '✅ Bien vu ! C’est la bonne zone OTE (entre 61.8% et 79%).'
                            : '❌ Pas tout à fait. L’OTE se trouve entre 61.8% et 79% de retracement.',
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
          ],
        ),
      ),
    );
  }
}
