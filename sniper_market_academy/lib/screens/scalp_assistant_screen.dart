import 'package:flutter/material.dart';

class ScalpAssistantScreen extends StatefulWidget {
  const ScalpAssistantScreen({super.key});

  @override
  State<ScalpAssistantScreen> createState() => _ScalpAssistantScreenState();
}

class _ScalpAssistantScreenState extends State<ScalpAssistantScreen> {
  int currentQuestion = 0;

  final List<Map<String, dynamic>> scenarios = [
    {
      'image': 'assets/images/scalp_ready_assistant_exercise1_graph.png',
      'question': 'Quelle est la meilleure zone de déséquilibre (FVG) ?',
      'options': ['Zone A', 'Zone B', 'Zone C'],
      'answer': 'Zone B'
    },
    // ➕ Tu peux ajouter d’autres scénarios ici
  ];

  String? selectedOption;
  bool answered = false;
  bool isCorrect = false;

  void validateAnswer() {
    setState(() {
      answered = true;
      isCorrect = selectedOption == scenarios[currentQuestion]['answer'];
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
    final data = scenarios[currentQuestion];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Scanner le Marché'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      extendBodyBehindAppBar: true,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF1D2671),
              Color(0xFFC33764),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 100, 16, 16),
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
                    data['image'],
                    height: 180,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              Text(
                data['question'],
                textAlign: TextAlign.center,
                style: const TextStyle(
                    fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
              ),
              const SizedBox(height: 20),
              ...data['options'].map<Widget>((option) {
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
                        fontSize: 16, fontWeight: FontWeight.bold),
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
                          fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    if (currentQuestion < scenarios.length - 1)
                      ElevatedButton(
                        onPressed: nextQuestion,
                        child: const Text('Suivant'),
                      )
                    else
                      const Text(
                        '🎯 Fin de la session de scan !',
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      )
                  ],
                )
            ],
          ),
        ),
      ),
    );
  }
}
