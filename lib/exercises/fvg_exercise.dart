import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FvgExercise extends StatefulWidget {
  const FvgExercise({super.key});

  @override
  State<FvgExercise> createState() => _FvgExerciseState();
}

class _FvgExerciseState extends State<FvgExercise> {
  int currentQuestion = 0;
  int selectedAnswer = -1;
  bool showResult = false;
  late DateTime _startTime;

  final List<Map<String, dynamic>> questions = [
    {
      'image': 'assets/images/fvg_example.png',
      'question': 'Quelle Zone est une FVG exploitable ?',
      'answers': [
        'Zone entre deux bougies vertes consécutives',
        'Zone entre une bougie rouge et une bougie verte sans chevauchement',
        'Zone au-dessus d’un order block haussier',
      ],
      'correctIndex': 1,
    },
    {
      'image': 'assets/images/fvg_exercise1_graph.png',
      'question': 'Quelle zone est une FVG exploitable ?',
      'answers': [
        'Zone entre les mèches qui se chevauchent',
        'Zone de déséquilibre formée par une impulsion brutale',
        'Zone entre deux dojis',
      ],
      'correctIndex': 1,
    },
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
    await prefs.setBool('module_fvg', true);
  }

  void validateAnswer() {
    setState(() {
      showResult = true;
    });
  }

  void nextQuestion() {
    setState(() {
      currentQuestion++;
      selectedAnswer = -1;
      showResult = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final question = questions[currentQuestion];

    return Scaffold(
      appBar: AppBar(
        title: const Text('🟧 FVG - Exercice'),
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
        child: ListView(
          children: [
            Text(
              question['question'],
              style: const TextStyle(fontSize: 18, color: Colors.white),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Image.asset(question['image']),
            const SizedBox(height: 24),
            ...List.generate(question['answers'].length, (index) {
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
                    question['answers'][index],
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
              Column(
                children: [
                  const SizedBox(height: 10),
                  Text(
                    selectedAnswer == question['correctIndex']
                        ? '✅ Bonne réponse !'
                        : '❌ Mauvaise réponse.',
                    style: TextStyle(
                      color: selectedAnswer == question['correctIndex']
                          ? Colors.green
                          : Colors.redAccent,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 10),
                  if (currentQuestion < questions.length - 1)
                    ElevatedButton(
                      onPressed: nextQuestion,
                      child: const Text('Question suivante'),
                    )
                  else
                    const Text(
                      '🎉 Fin de l\'exercice !',
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
