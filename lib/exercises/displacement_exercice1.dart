import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DisplacementExercice1 extends StatefulWidget {
  const DisplacementExercice1({Key? key}) : super(key: key);

  @override
  State<DisplacementExercice1> createState() => _DisplacementExercice1State();
}

class _DisplacementExercice1State extends State<DisplacementExercice1> {
  int selectedAnswer = -1;
  bool showResult = false;
  late DateTime _startTime;

  final int correctAnswerIndex = 1;

  final List<String> answers = [
    'Un simple retracement suivi d’un range',
    'Une impulsion forte qui casse une structure (Displacement)',
    'Un double bottom dans une tendance haussière',
  ];

  @override
  void initState() {
    super.initState();
    _startTime = DateTime.now();
  }

  @override
  void dispose() {
    final secondsSpent = DateTime.now().difference(_startTime).inSeconds;
    _saveTimeAndProgress(secondsSpent);
    super.dispose();
  }

  Future<void> _saveTimeAndProgress(int seconds) async {
    final prefs = await SharedPreferences.getInstance();
    final previous = prefs.getInt('time_spent') ?? 0;
    await prefs.setInt('time_spent', previous + seconds);
    await prefs.setBool('module_displacement', true);
  }

  void validateAnswer() {
    setState(() {
      showResult = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('⚡ Displacement - Exercice'),
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
              'Quelle structure représente un Displacement valide sur ce graphique ?',
              style: TextStyle(fontSize: 18, color: Colors.white),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Image.asset('assets/images/displacement_exercise1_graph.png'),
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
                      ? '✅ Bravo ! C’est une vraie impulsion (Displacement) avec cassure nette.'
                      : '❌ Mauvaise réponse. Le Displacement est une impulsion forte qui casse la structure.',
                  style: TextStyle(
                    color: selectedAnswer == correctAnswerIndex
                        ? Colors.green
                        : Colors.redAccent,
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
