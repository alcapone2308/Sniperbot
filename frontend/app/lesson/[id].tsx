import React, { useEffect, useState } from 'react';
import {
  View,
  Text,
  StyleSheet,
  ScrollView,
  TouchableOpacity,
  ActivityIndicator,
  Alert,
} from 'react-native';
import { useRouter, useLocalSearchParams } from 'expo-router';
import { Ionicons } from '@expo/vector-icons';
import { learningAPI, authAPI } from '../../services/api';
import { useAuthStore } from '../../store/authStore';

export default function LessonDetailScreen() {
  const router = useRouter();
  const { id } = useLocalSearchParams();
  const user = useAuthStore((state) => state.user);
  const updateUser = useAuthStore((state) => state.updateUser);
  const [lesson, setLesson] = useState<any>(null);
  const [quizzes, setQuizzes] = useState<any[]>([]);
  const [currentQuizIndex, setCurrentQuizIndex] = useState(0);
  const [selectedAnswer, setSelectedAnswer] = useState<number | null>(null);
  const [quizResults, setQuizResults] = useState<any[]>([]);
  const [showQuiz, setShowQuiz] = useState(false);
  const [loading, setLoading] = useState(true);
  const [lessonCompleted, setLessonCompleted] = useState(false);

  useEffect(() => {
    loadLessonData();
  }, [id]);

  const loadLessonData = async () => {
    try {
      const [lessonRes, quizzesRes] = await Promise.all([
        learningAPI.getLesson(id as string),
        learningAPI.getQuizzes(id as string),
      ]);
      setLesson(lessonRes.data);
      setQuizzes(quizzesRes.data.quizzes || []);
    } catch (error) {
      console.error('Error loading lesson:', error);
      Alert.alert('Erreur', 'Impossible de charger la leçon');
    } finally {
      setLoading(false);
    }
  };

  const completeLesson = async () => {
    try {
      const response = await learningAPI.completeLesson(
        id as string,
        user?.id || ''
      );
      
      // Update user XP
      const userRes = await authAPI.getUser(user?.id || '');
      updateUser(userRes.data);

      setLessonCompleted(true);
      Alert.alert(
        'Félicitations!',
        `Leçon terminée! Vous avez gagné ${response.data.xp_earned} XP`,
        [
          {
            text: 'Continuer',
            onPress: () => {
              if (quizzes.length > 0) {
                setShowQuiz(true);
              } else {
                router.back();
              }
            },
          },
        ]
      );
    } catch (error) {
      console.error('Error completing lesson:', error);
    }
  };

  const submitQuiz = async () => {
    if (selectedAnswer === null) {
      Alert.alert('Attention', 'Veuillez sélectionner une réponse');
      return;
    }

    try {
      const response = await learningAPI.submitQuiz({
        user_id: user?.id,
        quiz_id: quizzes[currentQuizIndex].id,
        answer: selectedAnswer,
      });

      const result = {
        correct: response.data.correct,
        explanation: response.data.explanation,
      };

      setQuizResults([...quizResults, result]);

      if (response.data.correct) {
        // Update user XP
        const userRes = await authAPI.getUser(user?.id || '');
        updateUser(userRes.data);
      }

      Alert.alert(
        response.data.correct ? 'Correct!' : 'Incorrect',
        response.data.explanation,
        [
          {
            text: 'Continuer',
            onPress: () => {
              if (currentQuizIndex < quizzes.length - 1) {
                setCurrentQuizIndex(currentQuizIndex + 1);
                setSelectedAnswer(null);
              } else {
                // All quizzes completed
                const correctCount = [...quizResults, result].filter(
                  (r) => r.correct
                ).length;
                Alert.alert(
                  'Quiz terminé!',
                  `Score: ${correctCount}/${quizzes.length}`,
                  [{ text: 'Retour', onPress: () => router.back() }]
                );
              }
            },
          },
        ]
      );
    } catch (error) {
      console.error('Error submitting quiz:', error);
      Alert.alert('Erreur', 'Impossible de soumettre la réponse');
    }
  };

  if (loading) {
    return (
      <View style={styles.loadingContainer}>
        <ActivityIndicator size="large" color="#10B981" />
      </View>
    );
  }

  if (!lesson) {
    return (
      <View style={styles.loadingContainer}>
        <Text style={styles.errorText}>Leçon introuvable</Text>
      </View>
    );
  }

  if (showQuiz && quizzes.length > 0) {
    const currentQuiz = quizzes[currentQuizIndex];

    return (
      <View style={styles.container}>
        <View style={styles.header}>
          <TouchableOpacity
            style={styles.backButton}
            onPress={() => setShowQuiz(false)}
          >
            <Ionicons name="arrow-back" size={24} color="#FFFFFF" />
          </TouchableOpacity>
          <Text style={styles.quizProgress}>
            Question {currentQuizIndex + 1} / {quizzes.length}
          </Text>
        </View>

        <ScrollView style={styles.content}>
          <View style={styles.quizCard}>
            <Text style={styles.quizQuestion}>{currentQuiz.question}</Text>

            <View style={styles.optionsContainer}>
              {currentQuiz.options.map((option: string, index: number) => (
                <TouchableOpacity
                  key={index}
                  style={[
                    styles.optionButton,
                    selectedAnswer === index && styles.selectedOption,
                  ]}
                  onPress={() => setSelectedAnswer(index)}
                >
                  <View style={styles.optionNumber}>
                    <Text style={styles.optionNumberText}>
                      {String.fromCharCode(65 + index)}
                    </Text>
                  </View>
                  <Text
                    style={[
                      styles.optionText,
                      selectedAnswer === index && styles.selectedOptionText,
                    ]}
                  >
                    {option}
                  </Text>
                </TouchableOpacity>
              ))}
            </View>

            <TouchableOpacity
              style={[
                styles.submitButton,
                selectedAnswer === null && styles.submitButtonDisabled,
              ]}
              onPress={submitQuiz}
              disabled={selectedAnswer === null}
            >
              <Text style={styles.submitButtonText}>Valider</Text>
            </TouchableOpacity>
          </View>
        </ScrollView>
      </View>
    );
  }

  return (
    <View style={styles.container}>
      <View style={styles.header}>
        <TouchableOpacity
          style={styles.backButton}
          onPress={() => router.back()}
        >
          <Ionicons name="arrow-back" size={24} color="#FFFFFF" />
        </TouchableOpacity>
        <Text style={styles.headerTitle}>Leçon {lesson.order}</Text>
      </View>

      <ScrollView style={styles.content}>
        <View style={styles.lessonCard}>
          <View style={styles.categoryBadge}>
            <Text style={styles.categoryText}>{lesson.category}</Text>
          </View>

          <Text style={styles.lessonTitle}>{lesson.title}</Text>
          <Text style={styles.lessonDescription}>{lesson.description}</Text>

          <View style={styles.divider} />

          <Text style={styles.contentTitle}>Contenu de la leçon</Text>
          <Text style={styles.lessonContent}>{lesson.content}</Text>

          <View style={styles.rewardContainer}>
            <Ionicons name="star" size={24} color="#F59E0B" />
            <Text style={styles.rewardText}>
              Complétez cette leçon pour gagner {lesson.xp_reward} XP
            </Text>
          </View>

          {!lessonCompleted && (
            <TouchableOpacity
              style={styles.completeButton}
              onPress={completeLesson}
            >
              <Text style={styles.completeButtonText}>
                Marquer comme terminée
              </Text>
              <Ionicons name="checkmark-circle" size={24} color="#FFFFFF" />
            </TouchableOpacity>
          )}

          {lessonCompleted && quizzes.length > 0 && (
            <TouchableOpacity
              style={styles.quizButton}
              onPress={() => setShowQuiz(true)}
            >
              <Text style={styles.quizButtonText}>Passer le quiz</Text>
              <Ionicons name="play-circle" size={24} color="#FFFFFF" />
            </TouchableOpacity>
          )}
        </View>
      </ScrollView>
    </View>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: '#0F172A',
  },
  loadingContainer: {
    flex: 1,
    backgroundColor: '#0F172A',
    justifyContent: 'center',
    alignItems: 'center',
  },
  header: {
    flexDirection: 'row',
    alignItems: 'center',
    padding: 20,
    paddingTop: 60,
    backgroundColor: '#1E293B',
    borderBottomWidth: 1,
    borderBottomColor: '#334155',
  },
  backButton: {
    marginRight: 16,
  },
  headerTitle: {
    fontSize: 20,
    fontWeight: '600',
    color: '#FFFFFF',
  },
  quizProgress: {
    fontSize: 16,
    fontWeight: '600',
    color: '#10B981',
  },
  content: {
    flex: 1,
  },
  lessonCard: {
    padding: 20,
  },
  categoryBadge: {
    backgroundColor: '#10B981' + '20',
    paddingHorizontal: 12,
    paddingVertical: 6,
    borderRadius: 6,
    alignSelf: 'flex-start',
    marginBottom: 16,
  },
  categoryText: {
    fontSize: 12,
    fontWeight: '600',
    color: '#10B981',
    textTransform: 'uppercase',
  },
  lessonTitle: {
    fontSize: 28,
    fontWeight: 'bold',
    color: '#FFFFFF',
    marginBottom: 12,
  },
  lessonDescription: {
    fontSize: 16,
    color: '#94A3B8',
    lineHeight: 24,
  },
  divider: {
    height: 1,
    backgroundColor: '#334155',
    marginVertical: 24,
  },
  contentTitle: {
    fontSize: 20,
    fontWeight: '600',
    color: '#FFFFFF',
    marginBottom: 16,
  },
  lessonContent: {
    fontSize: 16,
    color: '#E2E8F0',
    lineHeight: 26,
    marginBottom: 24,
  },
  rewardContainer: {
    flexDirection: 'row',
    alignItems: 'center',
    backgroundColor: '#78350F',
    padding: 16,
    borderRadius: 12,
    marginBottom: 24,
  },
  rewardText: {
    fontSize: 14,
    fontWeight: '600',
    color: '#FDE68A',
    marginLeft: 12,
    flex: 1,
  },
  completeButton: {
    backgroundColor: '#10B981',
    flexDirection: 'row',
    alignItems: 'center',
    justifyContent: 'center',
    padding: 16,
    borderRadius: 12,
    gap: 8,
  },
  completeButtonText: {
    fontSize: 18,
    fontWeight: '600',
    color: '#FFFFFF',
  },
  quizButton: {
    backgroundColor: '#3B82F6',
    flexDirection: 'row',
    alignItems: 'center',
    justifyContent: 'center',
    padding: 16,
    borderRadius: 12,
    gap: 8,
  },
  quizButtonText: {
    fontSize: 18,
    fontWeight: '600',
    color: '#FFFFFF',
  },
  quizCard: {
    padding: 20,
  },
  quizQuestion: {
    fontSize: 22,
    fontWeight: 'bold',
    color: '#FFFFFF',
    marginBottom: 32,
    lineHeight: 32,
  },
  optionsContainer: {
    gap: 12,
    marginBottom: 32,
  },
  optionButton: {
    flexDirection: 'row',
    alignItems: 'center',
    backgroundColor: '#1E293B',
    borderRadius: 12,
    padding: 16,
    borderWidth: 2,
    borderColor: '#334155',
  },
  selectedOption: {
    borderColor: '#10B981',
    backgroundColor: '#10B981' + '20',
  },
  optionNumber: {
    width: 32,
    height: 32,
    borderRadius: 16,
    backgroundColor: '#0F172A',
    justifyContent: 'center',
    alignItems: 'center',
    marginRight: 16,
  },
  optionNumberText: {
    fontSize: 16,
    fontWeight: 'bold',
    color: '#FFFFFF',
  },
  optionText: {
    fontSize: 16,
    color: '#FFFFFF',
    flex: 1,
  },
  selectedOptionText: {
    fontWeight: '600',
  },
  submitButton: {
    backgroundColor: '#10B981',
    padding: 16,
    borderRadius: 12,
    alignItems: 'center',
  },
  submitButtonDisabled: {
    opacity: 0.5,
  },
  submitButtonText: {
    fontSize: 18,
    fontWeight: '600',
    color: '#FFFFFF',
  },
  errorText: {
    fontSize: 16,
    color: '#94A3B8',
  },
});
