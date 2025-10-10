import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BOSExercise extends StatefulWidget {
  const BOSExercise({Key? key}) : super(key: key);

  @override
  State<BOSExercise> createState() => _BOSExerciseState();
}

class _BOSExerciseState extends State<BOSExercise> {
  int currentQuestion = 0;
  late DateTime _startTime;

  final List<Map<String, dynamic>> questions = [
    {
      'image': 'assets/images/bos_question_graph_1.png',
      'question': 'Quel est le bon point de Break of Structure (BOS) ?',
      'options': ['A', 'B', 'C'],
      'answer': 'B'
    },
    {
      'image': 'assets/images/bos_question_graph_2.png',
      'question': 'La structure change-t-elle vers haussier ou baissier ?',
      'options': ['Haussier', 'Baissier'],
      'answer': 'Haussier'
    },
  ];

  String? selectedOption;
  bool answered = false;
  bool isCorrect = false;

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
    await prefs.setBool('module_bos', true);
  }

  void validateAnswer() {
    setState(() {
      answered = true;
      isCorrect = selectedOption == questions[currentQuestion]['answer'];
    });
  }

  void nextQuestion() {
    setState(() {
      currentQuestion++;
      selectedOption = null;
      answered = false;
      isCorrect = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final questionData = questions[currentQuestion];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Exercice BOS'),
        backgroundColor: Colors.deepOrange,
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/menu_background.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 10,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(12),
                margin: const EdgeInsets.only(bottom: 16),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.asset(
                    questionData['image'],
                    height: 180,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              Text(
                questionData['question'],
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 20),
              ...questionData['options'].map<Widget>((option) {
                final isSelected = option == selectedOption;
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
                      option,
                      style: const TextStyle(color: Colors.white, fontSize: 16),
                    ),
                    onTap: answered
                        ? null
                        : () => setState(() {
                      selectedOption = option;
                    }),
                  ),
                );
              }).toList(),
              const SizedBox(height: 20),
              if (!answered)
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orangeAccent,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                    textStyle: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  onPressed: selectedOption != null ? validateAnswer : null,
                  child: const Text('Valider'),
                ),
              if (answered)
                Column(
                  children: [
                    Text(
                      isCorrect ? '✅ Bonne réponse !' : '❌ Mauvaise réponse.',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    if (currentQuestion < questions.length - 1)
                      ElevatedButton(
                        onPressed: nextQuestion,
                        child: const Text('Suivant'),
                      )
                    else
                      const Text(
                        '🎉 Fin de l\'exercice !',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}
