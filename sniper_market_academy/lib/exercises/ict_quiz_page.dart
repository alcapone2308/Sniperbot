import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ICTQuizPage extends StatefulWidget {
  const ICTQuizPage({Key? key}) : super(key: key);

  @override
  _ICTQuizPageState createState() => _ICTQuizPageState();
}

class _ICTQuizPageState extends State<ICTQuizPage> {
  int _currentQuestionIndex = 0;
  int _score = 0;
  bool _quizCompleted = false;
  String? _selectedAnswer;
  bool _showExplanation = false;

  final List<Map<String, dynamic>> _questions = [
    // ================ CONCEPTS DE BASE (8 questions) ================
    {
      'category': 'Concepts de Base',
      'question': 'Qu\'est-ce que l\'acronyme "ICT" signifie?',
      'answers': [
        {'text': 'Internal Crypto Trading', 'correct': false},
        {'text': 'Inner Circle Trading', 'correct': true},
        {'text': 'International Currency Technique', 'correct': false},
      ],
      'explanation': 'ICT signifie Inner Circle Trading, une méthodologie développée par Michael Huddleston.'
    },
    {
      'category': 'Concepts de Base',
      'question': 'Quel est l\'objectif principal du Smart Money Concept?',
      'answers': [
        {'text': 'Suivre les flux institutionnels', 'correct': true},
        {'text': 'Trouver des supports/résistances', 'correct': false},
        {'text': 'Automatiser le trading', 'correct': false},
      ],
      'explanation': 'Le SMC permet d\'identifier où les acteurs institutionnels placent leurs ordres.'
    },
    {
      'category': 'Concepts de Base',
      'question': 'Quel timeframe est le plus important en ICT?',
      'answers': [
        {'text': '1 Minute', 'correct': false},
        {'text': '15 Minutes', 'correct': false},
        {'text': 'Celui qui montre la structure institutionnelle', 'correct': true},
      ],
      'explanation': 'ICT privilégie l\'analyse de la structure plutôt qu\'un timeframe spécifique.'
    },
    // ================ ORDER BLOCKS (10 questions) ================
    {
      'category': 'Order Blocks',
      'question': 'Qu\'est-ce qu\'un Order Block Bullish?',
      'answers': [
        {'text': 'Zone de consolidation après une hausse', 'correct': true},
        {'text': 'Niveau de résistance classique', 'correct': false},
        {'text': 'Zone où le RSI est suracheté', 'correct': false},
      ],
      'explanation': 'Les OB Bullish montrent où les institutions ont acheté après un mouvement haussier.'
    },
    {
      'category': 'Order Blocks',
      'question': 'Comment identifier un vrai Order Block?',
      'answers': [
        {'text': 'Il doit précéder un mouvement directionnel fort', 'correct': true},
        {'text': 'C\'est toujours un doji sur le graphique', 'correct': false},
        {'text': 'Il correspond à un niveau round', 'correct': false},
      ],
      'explanation': 'Un vrai OB montre une accumulation avant un mouvement important.'
    },
    // ================ LIQUIDITY POOLS (7 questions) ================
    {
      'category': 'Liquidité',
      'question': 'Qu\'est-ce qu\'un pool de liquidité baissier?',
      'answers': [
        {'text': 'Zone sous le prix actuelle où les stops sont concentrés', 'correct': true},
        {'text': 'Niveau de support important', 'correct': false},
        {'text': 'Zone avec volume élevé de vente', 'correct': false},
      ],
      'explanation': 'Les pools baissiers attirent le prix pour faire déclencher les stops vendeurs.'
    },
    {
      'category': 'Liquidité',
      'question': 'Quel est le but des runs de liquidité?',
      'answers': [
        {'text': 'Remplir les ordres institutionnels à meilleur prix', 'correct': true},
        {'text': 'Créer de la volatilité', 'correct': false},
        {'text': 'Piéger les traders particuliers', 'correct': false},
      ],
      'explanation': 'Les institutions font "balayer" la liquidité pour exécuter leurs gros ordres.'
    },
    // ================ MARKET STRUCTURE (8 questions) ================
    {
      'category': 'Structure',
      'question': 'Qu\'est-ce qu\'un changement de structure haussier?',
      'answers': [
        {'text': 'Création d\'un plus haut suivi d\'un plus bas plus haut', 'correct': true},
        {'text': 'Cassure d\'un niveau de résistance', 'correct': false},
        {'text': 'RSI qui sort de la zone neutre', 'correct': false},
      ],
      'explanation': 'Le CHS montre un changement dans l\'équilibre des forces du marché.'
    },
    // ================ FVG/DISPLACEMENT (7 questions) ================
    {
      'category': 'FVG',
      'question': 'Qu\'est-ce qu\'un Fair Value Gap?',
      'answers': [
        {'text': 'Zone de déséquilibre entre deux bougies', 'correct': true},
        {'text': 'Écart entre prix et moyenne mobile', 'correct': false},
        {'text': 'Différence entre prix ouverts et clôtures', 'correct': false},
      ],
      'explanation': 'Le FVG montre une inefficacité temporaire que le marché doit combler.'
    },
    // ... (ajoutez les 30 autres questions selon le même format)
  ]..shuffle(); // Mélange aléatoire des questions

  void _answerQuestion(int answerIndex) async {
    final currentQuestion = _questions[_currentQuestionIndex];
    final isCorrect = currentQuestion['answers'][answerIndex]['correct'] == true;

    setState(() {
      _selectedAnswer = currentQuestion['answers'][answerIndex]['text'];
      if (isCorrect) _score++;
      _showExplanation = true;
    });

    await Future.delayed(const Duration(seconds: 2));

    if (_currentQuestionIndex < _questions.length - 1) {
      setState(() {
        _currentQuestionIndex++;
        _selectedAnswer = null;
        _showExplanation = false;
      });
    } else {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt('ict_quiz_score', _score);

      setState(() {
        _quizCompleted = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Maîtrise ICT/SMC - Quiz'),
        backgroundColor: Colors.deepOrange, // Couleur de l'AppBar
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/menu_background.png'), // Fond d'écran
            fit: BoxFit.cover,
          ),
        ),
        padding: const EdgeInsets.all(16.0),
        child: _quizCompleted ? _buildResults() : _buildQuestion(),
      ),
    );
  }

  Widget _buildQuestion() {
    final currentQuestion = _questions[_currentQuestionIndex];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Indicateur de catégorie
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.deepOrange.withOpacity(0.1), // Couleur de fond de la catégorie
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            currentQuestion['category'],
            style: TextStyle(
              color: Colors.deepOrange,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),

        const SizedBox(height: 16),

        // Question
        Text(
          currentQuestion['question'],
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.white, // Couleur du texte de la question
          ),
        ),

        const SizedBox(height: 24),

        // Réponses
        ...List.generate(currentQuestion['answers'].length, (index) {
          final answer = currentQuestion['answers'][index];
          final isSelected = _selectedAnswer == answer['text'];

          return GestureDetector(
            onTap: _showExplanation ? null : () => _answerQuestion(index),
            child: Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isSelected
                    ? answer['correct']
                    ? Colors.green[50]
                    : Colors.red[50]
                    : Colors.black38, // Couleur de fond par défaut
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isSelected
                      ? answer['correct']
                      ? Colors.green
                      : Colors.red
                      : Colors.white54, // Couleur de bordure par défaut
                ),
              ),
              child: Text(
                answer['text'],
                style: TextStyle(
                  color: isSelected
                      ? answer['correct']
                      ? Colors.green[900]
                      : Colors.red[900]
                      : Colors.white, // Couleur du texte par défaut
                ),
              ),
            ),
          );
        }),

        // Explication
        if (_showExplanation)
          Padding(
            padding: const EdgeInsets.only(top: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Explication:',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  currentQuestion['explanation'],
                  style: const TextStyle(color: Colors.white), // Couleur de l'explication
                ),
              ],
            ),
          ),

        const Spacer(),

        // Barre de progression
        LinearProgressIndicator(
          value: (_currentQuestionIndex + 1) / _questions.length,
          backgroundColor: Colors.grey[200],
          color: Colors.deepOrange, // Couleur de la barre de progression
        ),
        const SizedBox(height: 8),
        Text(
          'Question ${_currentQuestionIndex + 1}/${_questions.length}',
          textAlign: TextAlign.center,
          style: const TextStyle(color: Colors.white), // Couleur du texte de la question
        ),
      ],
    );
  }

  Widget _buildResults() {
    final percentage = (_score / _questions.length * 100).round();
    String resultText;
    Color resultColor;

    if (percentage >= 80) {
      resultText = 'Expert ICT!';
      resultColor = Colors.green;
    } else if (percentage >= 50) {
      resultText = 'Bonne compréhension';
      resultColor = Colors.orange;
    } else {
      resultText = 'À étudier davantage';
      resultColor = Colors.red;
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          resultText,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: resultColor,
          ),
        ),

        const SizedBox(height: 32),

        Stack(
          alignment: Alignment.center,
          children: [
            SizedBox(
              width: 150,
              height: 150,
              child: CircularProgressIndicator(
                value: percentage / 100,
                strokeWidth: 12,
                color: resultColor,
                backgroundColor: Colors.grey[200],
              ),
            ),
            Text(
              '$percentage%',
              style: const TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.white, // Couleur du texte du pourcentage
              ),
            ),
          ],
        ),

        const SizedBox(height: 32),

        Text(
          'Score: $_score/${_questions.length}',
          style: const TextStyle(fontSize: 18, color: Colors.white), // Couleur du score
        ),

        const SizedBox(height: 40),

        OutlinedButton(
          onPressed: () {
            setState(() {
              _currentQuestionIndex = 0;
              _score = 0;
              _quizCompleted = false;
            });
          },
          child: const Text('Recommencer le quiz'),
        ),
      ],
    );
  }
}