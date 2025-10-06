import 'package:flutter/material.dart';

class SetupCompletExercises extends StatefulWidget {
  const SetupCompletExercises({Key? key}) : super(key: key);

  @override
  State<SetupCompletExercises> createState() => _SetupCompletExercisesState();
}

class _SetupCompletExercisesState extends State<SetupCompletExercises> {
  int currentQuestion = 0;
  int selectedAnswer = -1;
  bool showResult = false;

  final List<Map<String, dynamic>> questions = [
    {
      'image': 'assets/images/setup_complet_exercise1_graph.png',
      'question': 'Quelle serait la zone d’entrée idéale pour un setup acheteur basé sur SMC ?',
      'answers': [
        'Le sommet du range',
        'Le FVG au-dessus du BOS',
        'L’Order Block + OTE (zone d’achat)',
      ],
      'correctIndex': 2,
    },
    {
      'image': 'assets/images/setup_complet_exercise2_graph.png',
      'question': 'Quelle serait la zone d’entrée idéale pour un setup vendeur basé sur SMC ?',
      'answers': [
        'Le creux du range',
        'Le FVG sous le BOS',
        'L’Order Block + OTE (zone de vente)',
      ],
      'correctIndex': 2,
    },
  ];

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
        title: const Text('📈 Setup Complet - Exercices'),
        backgroundColor: Colors.deepOrange,
      ),
      body: SingleChildScrollView(
        child: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/menu_background.png'),
              fit: BoxFit.cover,
            ),
          ),
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Text(
                question['question'],
                style: const TextStyle(fontSize: 18, color: Colors.white),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Image.asset(
                question['image'],
                width: MediaQuery.of(context).size.width * 0.95,
                fit: BoxFit.contain,
              ),
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
                          ? '✅ Bien vu ! C’est la zone optimale selon les critères SMC (liquidity, OB, OTE).'
                          : '❌ Mauvaise réponse. L’entrée idéale se trouve dans l’Order Block + OTE après la prise de liquidité.',
                      style: TextStyle(
                        color: selectedAnswer == question['correctIndex'] ? Colors.green : Colors.redAccent,
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
      ),
    );
  }
}
