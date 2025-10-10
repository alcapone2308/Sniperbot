import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import '../models/quiz_data.dart';

class QuizProvider with ChangeNotifier {
  late Box _quizBox;

  int _totalQuizzesCompleted = 0;
  int _totalCorrectAnswers = 0;
  int _totalQuestions = 0;
  int _currentStreak = 0;
  int _bestStreak = 0;
  Map<String, int> _categoryScores = {};
  List<Map<String, dynamic>> _quizHistory = [];
  Map<String, bool> _completedQuizzes = {};

  // ✅ Getters
  int get totalQuizzesCompleted => _totalQuizzesCompleted;
  int get totalCorrectAnswers => _totalCorrectAnswers;
  int get totalQuestions => _totalQuestions;
  int get currentStreak => _currentStreak; // ✅ corrigé (plus d’espace)
  int get bestStreak => _bestStreak;
  Map<String, int> get categoryScores => _categoryScores;
  List<Map<String, dynamic>> get quizHistory => _quizHistory;

  double get accuracy {
    if (_totalQuestions == 0) return 0.0;
    return (_totalCorrectAnswers / _totalQuestions) * 100;
  }

  bool isQuizCompleted(String quizId) {
    return _completedQuizzes[quizId] ?? false;
  }

  Future<void> loadProgress() async {
    _quizBox = Hive.box('quiz_data');

    _totalQuizzesCompleted = _quizBox.get('total_quizzes_completed', defaultValue: 0);
    _totalCorrectAnswers = _quizBox.get('total_correct_answers', defaultValue: 0);
    _totalQuestions = _quizBox.get('total_questions', defaultValue: 0);
    _currentStreak = _quizBox.get('current_streak', defaultValue: 0);
    _bestStreak = _quizBox.get('best_streak', defaultValue: 0);

    final categoryData = _quizBox.get('category_scores', defaultValue: {});
    _categoryScores = Map<String, int>.from(categoryData);

    final historyData = _quizBox.get('quiz_history', defaultValue: []);
    _quizHistory = List<Map<String, dynamic>>.from(historyData);

    final completedData = _quizBox.get('completed_quizzes', defaultValue: {});
    _completedQuizzes = Map<String, bool>.from(completedData);

    notifyListeners();
  }

  Future<void> _saveProgress() async {
    await _quizBox.put('total_quizzes_completed', _totalQuizzesCompleted);
    await _quizBox.put('total_correct_answers', _totalCorrectAnswers);
    await _quizBox.put('total_questions', _totalQuestions);
    await _quizBox.put('current_streak', _currentStreak);
    await _quizBox.put('best_streak', _bestStreak);
    await _quizBox.put('category_scores', _categoryScores);
    await _quizBox.put('quiz_history', _quizHistory);
    await _quizBox.put('completed_quizzes', _completedQuizzes);
  }

  /// ✅ Soumettre une réponse de quiz
  Future<void> submitAnswer({
    required String quizId,
    required String category,
    required int questionIndex,
    required int selectedAnswer,
    required int correctAnswer,
    required int totalQuestions,
  }) async {
    _totalQuestions++;

    final isCorrect = selectedAnswer == correctAnswer;

    if (isCorrect) {
      _totalCorrectAnswers++;
      _currentStreak++;

      if (_currentStreak > _bestStreak) {
        _bestStreak = _currentStreak;
      }

      _categoryScores[category] = (_categoryScores[category] ?? 0) + 1;
    } else {
      _currentStreak = 0;
    }

    await _saveProgress();
    notifyListeners();
  }

  /// ✅ Compléter un quiz entier
  Future<void> completeQuiz({
    required String quizId,
    required String category,
    required int correctAnswers,
    required int totalQuestions,
    required int score,
  }) async {
    _totalQuizzesCompleted++;
    _completedQuizzes[quizId] = true;

    _quizHistory.insert(0, {
      'quizId': quizId,
      'category': category,
      'correctAnswers': correctAnswers,
      'totalQuestions': totalQuestions,
      'score': score,
      'date': DateTime.now().toIso8601String(),
    });

    if (_quizHistory.length > 50) {
      _quizHistory = _quizHistory.sublist(0, 50);
    }

    await _saveProgress();
    notifyListeners();
  }

  /// ✅ Réinitialiser la progression
  Future<void> resetProgress() async {
    _totalQuizzesCompleted = 0;
    _totalCorrectAnswers = 0;
    _totalQuestions = 0;
    _currentStreak = 0;
    _bestStreak = 0;
    _categoryScores = {};
    _quizHistory = [];
    _completedQuizzes = {};

    await _saveProgress();
    notifyListeners();
  }

  List<QuizData> getAvailableQuizzes() {
    return QuizData.getAllQuizzes();
  }

  QuizData? getQuizById(String quizId) {
    try {
      return QuizData.getAllQuizzes().firstWhere(
            (quiz) => quiz.id == quizId,
      );
    } catch (e) {
      return null;
    }
  }
}
