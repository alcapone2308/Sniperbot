import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OrderblockExercice1 extends StatefulWidget {
  const OrderblockExercice1({Key? key}) : super(key: key);

  @override
  State<OrderblockExercice1> createState() => _OrderblockExercice1State();
}

class _OrderblockExercice1State extends State<OrderblockExercice1> {
  int selectedAnswer = -1;
  bool showResult = false;
  late DateTime _startTime;

  final int correctAnswerIndex = 2;

  final List<String> answers = [
    'La dernière bougie rouge avant un mouvement baissier',
    'Un double top qui casse un support',
    'La dernière bougie haussière avant l’impulsion baissière',
    'Une mèche isolée dans un range',
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
    await prefs.setBool('module_orderblock', true);
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
        title: const Text('🧱 Order Block - Exercice'),
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
              'Quel élément correspond à un Order Block baissier valide ?',
              style: TextStyle(fontSize: 18, color: Colors.white),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Image.asset('assets/images/orderblock_exercise1_graph.png'),
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
                      ? '✅ Exact ! C’est bien la dernière bougie haussière avant la chute.'
                      : '❌ Non. Un OB baissier est la dernière bougie verte avant l’impulsion baissière.',
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
