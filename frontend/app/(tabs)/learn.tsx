import React, { useEffect, useState } from 'react';
import {
  View,
  Text,
  StyleSheet,
  ScrollView,
  TouchableOpacity,
  ActivityIndicator,
} from 'react-native';
import { Ionicons } from '@expo/vector-icons';
import { useRouter } from 'expo-router';
import { learningAPI, progressAPI } from '../../services/api';
import { useAuthStore } from '../../store/authStore';

export default function LearnScreen() {
  const router = useRouter();
  const user = useAuthStore((state) => state.user);
  const [lessons, setLessons] = useState<any[]>([]);
  const [loading, setLoading] = useState(true);
  const [progress, setProgress] = useState<any>(null);

  useEffect(() => {
    loadLessons();
  }, []);

  const loadLessons = async () => {
    try {
      const [lessonsRes, progressRes] = await Promise.all([
        learningAPI.getLessons(),
        progressAPI.getProgress(user?.id || ''),
      ]);
      setLessons(lessonsRes.data.lessons || []);
      setProgress(progressRes.data);
    } catch (error) {
      console.error('Error loading lessons:', error);
    } finally {
      setLoading(false);
    }
  };

  const getDifficultyColor = (difficulty: string) => {
    switch (difficulty) {
      case 'beginner':
        return '#10B981';
      case 'intermediate':
        return '#F59E0B';
      case 'advanced':
        return '#EF4444';
      default:
        return '#64748B';
    }
  };

  const getDifficultyLabel = (difficulty: string) => {
    switch (difficulty) {
      case 'beginner':
        return 'Débutant';
      case 'intermediate':
        return 'Intermédiaire';
      case 'advanced':
        return 'Avancé';
      default:
        return difficulty;
    }
  };

  const getCategoryIcon = (category: string) => {
    switch (category) {
      case 'crypto':
        return 'logo-bitcoin';
      case 'stocks':
        return 'trending-up';
      case 'forex':
        return 'cash';
      default:
        return 'book';
    }
  };

  if (loading) {
    return (
      <View style={styles.loadingContainer}>
        <ActivityIndicator size="large" color="#10B981" />
      </View>
    );
  }

  const completedLessons = progress?.completed_lessons || [];

  return (
    <ScrollView style={styles.container}>
      <View style={styles.header}>
        <Text style={styles.title}>Apprentissage</Text>
        <Text style={styles.subtitle}>
          Progressez à votre rythme et devenez un expert
        </Text>
      </View>

      {/* Progress Overview */}
      <View style={styles.progressCard}>
        <View style={styles.progressHeader}>
          <Ionicons name="trophy" size={32} color="#F59E0B" />
          <View style={styles.progressInfo}>
            <Text style={styles.progressTitle}>Votre progression</Text>
            <Text style={styles.progressText}>
              {completedLessons.length} / {lessons.length} leçons complétées
            </Text>
          </View>
        </View>
        <View style={styles.progressBar}>
          <View
            style={[
              styles.progressFill,
              {
                width: `${(completedLessons.length / lessons.length) * 100}%`,
              },
            ]}
          />
        </View>
      </View>

      {/* Lessons List */}
      <View style={styles.lessonsSection}>
        <Text style={styles.sectionTitle}>Leçons disponibles</Text>
        {lessons.map((lesson, index) => {
          const isCompleted = completedLessons.includes(lesson.id);
          const isLocked = index > 0 && !completedLessons.includes(lessons[index - 1].id);

          return (
            <TouchableOpacity
              key={lesson.id}
              style={[
                styles.lessonCard,
                isCompleted && styles.completedCard,
                isLocked && styles.lockedCard,
              ]}
              onPress={() => {
                if (!isLocked) {
                  router.push(`/lesson/${lesson.id}`);
                }
              }}
              disabled={isLocked}
            >
              <View style={styles.lessonIconContainer}>
                <View
                  style={[
                    styles.lessonIcon,
                    { backgroundColor: getDifficultyColor(lesson.difficulty) + '20' },
                  ]}
                >
                  <Ionicons
                    name={isLocked ? 'lock-closed' : getCategoryIcon(lesson.category)}
                    size={24}
                    color={isLocked ? '#64748B' : getDifficultyColor(lesson.difficulty)}
                  />
                </View>
              </View>

              <View style={styles.lessonContent}>
                <View style={styles.lessonHeader}>
                  <Text style={styles.lessonOrder}>Leçon {lesson.order}</Text>
                  <View
                    style={[
                      styles.difficultyBadge,
                      { backgroundColor: getDifficultyColor(lesson.difficulty) + '20' },
                    ]}
                  >
                    <Text
                      style={[
                        styles.difficultyText,
                        { color: getDifficultyColor(lesson.difficulty) },
                      ]}
                    >
                      {getDifficultyLabel(lesson.difficulty)}
                    </Text>
                  </View>
                </View>

                <Text style={[styles.lessonTitle, isLocked && styles.lockedText]}>
                  {lesson.title}
                </Text>
                <Text style={[styles.lessonDescription, isLocked && styles.lockedText]}>
                  {lesson.description}
                </Text>

                <View style={styles.lessonFooter}>
                  <View style={styles.xpBadge}>
                    <Ionicons name="star" size={14} color="#F59E0B" />
                    <Text style={styles.xpText}>+{lesson.xp_reward} XP</Text>
                  </View>
                  {isCompleted && (
                    <View style={styles.completedBadge}>
                      <Ionicons name="checkmark-circle" size={16} color="#10B981" />
                      <Text style={styles.completedText}>Terminé</Text>
                    </View>
                  )}
                  {isLocked && (
                    <Text style={styles.lockedText}>Complétez la leçon précédente</Text>
                  )}
                </View>
              </View>

              <Ionicons
                name={isLocked ? 'lock-closed' : 'chevron-forward'}
                size={24}
                color={isLocked ? '#64748B' : '#94A3B8'}
              />
            </TouchableOpacity>
          );
        })}
      </View>
    </ScrollView>
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
    padding: 20,
    paddingTop: 60,
  },
  title: {
    fontSize: 32,
    fontWeight: 'bold',
    color: '#FFFFFF',
    marginBottom: 8,
  },
  subtitle: {
    fontSize: 16,
    color: '#94A3B8',
  },
  progressCard: {
    backgroundColor: '#1E293B',
    borderRadius: 16,
    padding: 20,
    marginHorizontal: 20,
    marginBottom: 24,
    borderWidth: 1,
    borderColor: '#334155',
  },
  progressHeader: {
    flexDirection: 'row',
    alignItems: 'center',
    marginBottom: 16,
  },
  progressInfo: {
    marginLeft: 16,
    flex: 1,
  },
  progressTitle: {
    fontSize: 18,
    fontWeight: '600',
    color: '#FFFFFF',
  },
  progressText: {
    fontSize: 14,
    color: '#94A3B8',
    marginTop: 4,
  },
  progressBar: {
    height: 8,
    backgroundColor: '#334155',
    borderRadius: 4,
    overflow: 'hidden',
  },
  progressFill: {
    height: '100%',
    backgroundColor: '#10B981',
    borderRadius: 4,
  },
  lessonsSection: {
    padding: 20,
  },
  sectionTitle: {
    fontSize: 20,
    fontWeight: '600',
    color: '#FFFFFF',
    marginBottom: 16,
  },
  lessonCard: {
    backgroundColor: '#1E293B',
    borderRadius: 12,
    padding: 16,
    flexDirection: 'row',
    alignItems: 'center',
    marginBottom: 12,
    borderWidth: 1,
    borderColor: '#334155',
  },
  completedCard: {
    borderColor: '#10B981',
  },
  lockedCard: {
    opacity: 0.6,
  },
  lessonIconContainer: {
    marginRight: 16,
  },
  lessonIcon: {
    width: 56,
    height: 56,
    borderRadius: 12,
    justifyContent: 'center',
    alignItems: 'center',
  },
  lessonContent: {
    flex: 1,
  },
  lessonHeader: {
    flexDirection: 'row',
    alignItems: 'center',
    marginBottom: 8,
  },
  lessonOrder: {
    fontSize: 12,
    fontWeight: '600',
    color: '#64748B',
    marginRight: 8,
  },
  difficultyBadge: {
    paddingHorizontal: 8,
    paddingVertical: 4,
    borderRadius: 4,
  },
  difficultyText: {
    fontSize: 11,
    fontWeight: '600',
  },
  lessonTitle: {
    fontSize: 16,
    fontWeight: '600',
    color: '#FFFFFF',
    marginBottom: 4,
  },
  lessonDescription: {
    fontSize: 14,
    color: '#94A3B8',
    marginBottom: 12,
  },
  lessonFooter: {
    flexDirection: 'row',
    alignItems: 'center',
    gap: 12,
  },
  xpBadge: {
    flexDirection: 'row',
    alignItems: 'center',
  },
  xpText: {
    fontSize: 12,
    fontWeight: '600',
    color: '#F59E0B',
    marginLeft: 4,
  },
  completedBadge: {
    flexDirection: 'row',
    alignItems: 'center',
  },
  completedText: {
    fontSize: 12,
    fontWeight: '600',
    color: '#10B981',
    marginLeft: 4,
  },
  lockedText: {
    color: '#64748B',
    fontSize: 12,
  },
});
