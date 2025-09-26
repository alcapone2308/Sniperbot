import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ScalpReadyAssistantExercise1 extends StatefulWidget {
  const ScalpReadyAssistantExercise1({Key? key}) : super(key: key);

  @override
  State<ScalpReadyAssistantExercise1> createState() => _ScalpReadyAssistantExercise1State();
}

class _ScalpReadyAssistantExercise1State extends State<ScalpReadyAssistantExercise1> {
  int selectedAnswer = -1;
  bool showResult = false;
  late DateTime startTime;

  final int correctAnswerIndex = 0;
  final List<String> answers = [
    'Le prix casse une structure, crée un FVG et revient en OTE',
    'Le prix est en range sans indication claire',
    'Il s’agit d’un Order Block non respecté',
  ];

  @override
  void initState() {
    super.initState();
    startTime = DateTime.now();
  }

  @override
  void dispose() {
    final secondsSpent = DateTime.now().difference(startTime).inSeconds;
    saveTimeAndProgress(secondsSpent);
    super.dispose();
  }

  Future<void> saveTimeAndProgress(int seconds) async {
    final prefs = await SharedPreferences.getInstance();
    final total = prefs.getInt('time_spent') ?? 0;
    await prefs.setInt('time_spent', total + seconds);
    await prefs.setBool('module_scalp_ready', true);
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
        title: const Text('🔍 Scalp Ready - Exercice 1'),
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
              'Que se passe-t-il ici ? Observe le graphique :',
              style: TextStyle(fontSize: 18, color: Colors.white),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Image.asset('assets/images/scalp_ready_exercise1.png'),
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
                      ? '✅ Excellent ! Tu as repéré la séquence complète d\'un scalp basé sur les concepts SMC.'
                      : '❌ Regarde bien : il faut une cassure, un FVG puis un retour en OTE.',
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
