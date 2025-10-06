import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/quiz_provider.dart';
import '../models/quiz_data.dart';

class QuizListPage extends StatelessWidget {
  const QuizListPage({super.key});

  Color _getDifficultyColor(String difficulty) {
    switch (difficulty) {
      case 'easy':
        return Colors.green;
      case 'medium':
        return Colors.orange;
      case 'hard':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0E1A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1A1F2E),
        title: const Text('📚 Quiz ICT/SMC'),
      ),
      body: Consumer<QuizProvider>(
        builder: (context, quizProvider, _) {
          final quizzes = quizProvider.getAvailableQuizzes();

          return Column(
            children: [
              // Stats Header
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFFFF6B35), Color(0xFFFF8C42)],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFFFF6B35).withOpacity(0.3),
                      blurRadius: 20,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildStatColumn(
                      '${quizProvider.totalQuizzesCompleted}',
                      'Complétés',
                      Icons.check_circle,
                    ),
                    _buildStatColumn(
                      '${quizProvider.accuracy.toStringAsFixed(1)}%',
                      'Précision',
                      Icons.target,
                    ),
                    _buildStatColumn(
                      '${quizProvider.currentStreak}',
                      'Streak',
                      Icons.local_fire_department,
                    ),
                  ],
                ),
              ),

              // Quiz List
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: quizzes.length,
                  itemBuilder: (context, index) {
                    final quiz = quizzes[index];
                    final isCompleted = quizProvider.isQuizCompleted(quiz.id);

                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => QuizDetailPage(quiz: quiz),
                          ),
                        );
                      },
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 16),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: const Color(0xFF1A1F2E),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: isCompleted
                                ? Colors.green.withOpacity(0.5)
                                : Colors.white10,
                            width: 2,
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    quiz.title,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                if (isCompleted)
                                  const Icon(
                                    Icons.check_circle,
                                    color: Colors.green,
                                    size: 24,
                                  ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text(
                              quiz.description,
                              style: const TextStyle(
                                color: Colors.white70,
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 6,
                                  ),
                                  decoration: BoxDecoration(
                                    color: _getDifficultyColor(quiz.difficulty)
                                        .withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    quiz.difficulty.toUpperCase(),
                                    style: TextStyle(
                                      color: _getDifficultyColor(quiz.difficulty),
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 6,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.blue.withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    quiz.category,
                                    style: const TextStyle(
                                      color: Colors.blue,
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                const Spacer(),
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.star,
                                      color: Colors.amber,
                                      size: 16,
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      '+${quiz.xpReward} XP',
                                      style: const TextStyle(
                                        color: Colors.amber,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text(
                              '${quiz.questions.length} questions',
                              style: const TextStyle(
                                color: Colors.white30,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildStatColumn(String value, String label, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: Colors.white, size: 28),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}

// Quiz Detail Page
class QuizDetailPage extends StatefulWidget {
  final QuizData quiz;

  const QuizDetailPage({super.key, required this.quiz});

  @override
  State<QuizDetailPage> createState() => _QuizDetailPageState();
}

class _QuizDetailPageState extends State<QuizDetailPage> {
  int currentQuestionIndex = 0;
  int? selectedAnswer;
  int correctAnswers = 0;
  bool showExplanation = false;
  bool quizCompleted = false;

  void _submitAnswer() {
    if (selectedAnswer == null) return;

    final question = widget.quiz.questions[currentQuestionIndex];
    final isCorrect = selectedAnswer == question.correctAnswer;

    if (isCorrect) {
      correctAnswers++;
    }

    Provider.of<QuizProvider>(context, listen: false).submitAnswer(
      quizId: widget.quiz.id,
      category: widget.quiz.category,
      questionIndex: currentQuestionIndex,
      selectedAnswer: selectedAnswer!,
      correctAnswer: question.correctAnswer,
      totalQuestions: widget.quiz.questions.length,
    );

    setState(() {
      showExplanation = true;
    });
  }

  void _nextQuestion() {
    if (currentQuestionIndex < widget.quiz.questions.length - 1) {
      setState(() {
        currentQuestionIndex++;
        selectedAnswer = null;
        showExplanation = false;
      });
    } else {
      _completeQuiz();
    }
  }

  void _completeQuiz() {
    final score = (correctAnswers / widget.quiz.questions.length * 100).round();

    Provider.of<QuizProvider>(context, listen: false).completeQuiz(
      quizId: widget.quiz.id,
      category: widget.quiz.category,
      correctAnswers: correctAnswers,
      totalQuestions: widget.quiz.questions.length,
      score: score,
    );

    setState(() {
      quizCompleted = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (quizCompleted) {
      return _buildCompletionScreen();
    }

    final question = widget.quiz.questions[currentQuestionIndex];

    return Scaffold(
      backgroundColor: const Color(0xFF0A0E1A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1A1F2E),
        title: Text('Question ${currentQuestionIndex + 1}/${widget.quiz.questions.length}'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Progress Bar
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: LinearProgressIndicator(
                value: (currentQuestionIndex + 1) / widget.quiz.questions.length,
                backgroundColor: Colors.white10,
                valueColor: const AlwaysStoppedAnimation(Color(0xFFFF6B35)),
                minHeight: 8,
              ),
            ),
            const SizedBox(height: 24),

            // Question
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFF1A1F2E),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text(
                question.question,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Options
            Expanded(
              child: ListView.builder(
                itemCount: question.options.length,
                itemBuilder: (context, index) {
                  final isSelected = selectedAnswer == index;
                  final isCorrect = index == question.correctAnswer;
                  final showResult = showExplanation;

                  Color borderColor = Colors.white10;
                  Color bgColor = const Color(0xFF1A1F2E);

                  if (showResult) {
                    if (isCorrect) {
                      borderColor = Colors.green;
                      bgColor = Colors.green.withOpacity(0.1);
                    } else if (isSelected) {
                      borderColor = Colors.red;
                      bgColor = Colors.red.withOpacity(0.1);
                    }
                  } else if (isSelected) {
                    borderColor = const Color(0xFFFF6B35);
                    bgColor = const Color(0xFFFF6B35).withOpacity(0.1);
                  }

                  return GestureDetector(
                    onTap: showExplanation
                        ? null
                        : () {
                            setState(() {
                              selectedAnswer = index;
                            });
                          },
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: bgColor,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: borderColor, width: 2),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 32,
                            height: 32,
                            decoration: BoxDecoration(
                              color: borderColor,
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: Text(
                                String.fromCharCode(65 + index),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              question.options[index],
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                              ),
                            ),
                          ),
                          if (showResult && isCorrect)
                            const Icon(Icons.check_circle, color: Colors.green),
                          if (showResult && isSelected && !isCorrect)
                            const Icon(Icons.cancel, color: Colors.red),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),

            // Explanation
            if (showExplanation) ...[
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.blue.withOpacity(0.3)),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.lightbulb, color: Colors.blue, size: 24),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        question.explanation,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
            ],

            // Action Button
            ElevatedButton(
              onPressed: showExplanation ? _nextQuestion : _submitAnswer,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFF6B35),
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                showExplanation
                    ? (currentQuestionIndex < widget.quiz.questions.length - 1
                        ? 'Question Suivante'
                        : 'Terminer le Quiz')
                    : 'Valider',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCompletionScreen() {
    final score = (correctAnswers / widget.quiz.questions.length * 100).round();

    return Scaffold(
      backgroundColor: const Color(0xFF0A0E1A),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                score >= 80
                    ? Icons.emoji_events
                    : score >= 60
                        ? Icons.thumb_up
                        : Icons.refresh,
                size: 100,
                color: score >= 80
                    ? Colors.amber
                    : score >= 60
                        ? Colors.green
                        : Colors.orange,
              ),
              const SizedBox(height: 24),
              Text(
                score >= 80
                    ? '🎉 Excellent !'
                    : score >= 60
                        ? '👍 Bien joué !'
                        : '💪 Continue !',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Score: $score%',
                style: const TextStyle(
                  color: Color(0xFFFF6B35),
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                '$correctAnswers/${widget.quiz.questions.length} bonnes réponses',
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 18,
                ),
              ),
              const SizedBox(height: 32),
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.amber.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.amber.withOpacity(0.3)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.star, color: Colors.amber, size: 32),
                    const SizedBox(width: 12),
                    Text(
                      '+${widget.quiz.xpReward} XP',
                      style: const TextStyle(
                        color: Colors.amber,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 48),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFF6B35),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 48,
                    vertical: 16,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Retour aux Quiz',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
