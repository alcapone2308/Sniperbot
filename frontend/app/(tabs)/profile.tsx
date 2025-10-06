import React, { useState } from 'react';
import {
  View,
  Text,
  StyleSheet,
  ScrollView,
  TouchableOpacity,
  TextInput,
  Modal,
  Alert,
} from 'react-native';
import { Ionicons } from '@expo/vector-icons';
import { useRouter } from 'expo-router';
import { useAuthStore } from '../../store/authStore';
import { aiAPI } from '../../services/api';

export default function ProfileScreen() {
  const router = useRouter();
  const user = useAuthStore((state) => state.user);
  const logout = useAuthStore((state) => state.logout);
  const [aiModalVisible, setAiModalVisible] = useState(false);
  const [aiMessage, setAiMessage] = useState('');
  const [aiResponse, setAiResponse] = useState('');
  const [aiLoading, setAiLoading] = useState(false);

  const handleLogout = () => {
    Alert.alert(
      'Déconnexion',
      'Êtes-vous sûr de vouloir vous déconnecter ?',
      [
        { text: 'Annuler', style: 'cancel' },
        {
          text: 'Déconnexion',
          style: 'destructive',
          onPress: async () => {
            await logout();
            router.replace('/');
          },
        },
      ]
    );
  };

  const askAI = async () => {
    if (!aiMessage.trim()) return;

    setAiLoading(true);
    setAiResponse('');
    try {
      const response = await aiAPI.askAssistant(
        user?.id || '',
        aiMessage,
        `Niveau de l'utilisateur: ${user?.level}, XP: ${user?.xp}`
      );
      setAiResponse(response.data.response);
    } catch (error) {
      console.error('AI error:', error);
      setAiResponse('Désolé, je ne peux pas répondre pour le moment.');
    } finally {
      setAiLoading(false);
    }
  };

  const xpForNextLevel = user ? (user.level * 1000) : 1000;
  const progressToNextLevel = user ? ((user.xp % 1000) / 1000) * 100 : 0;

  return (
    <View style={styles.container}>
      <ScrollView>
        {/* Header */}
        <View style={styles.header}>
          <View style={styles.avatarContainer}>
            <View style={styles.avatar}>
              <Ionicons name="person" size={48} color="#10B981" />
            </View>
            <View style={styles.levelBadge}>
              <Text style={styles.levelText}>{user?.level}</Text>
            </View>
          </View>
          <Text style={styles.userName}>{user?.name}</Text>
          <Text style={styles.userEmail}>{user?.email}</Text>
        </View>

        {/* Level Progress */}
        <View style={styles.section}>
          <View style={styles.progressCard}>
            <View style={styles.progressHeader}>
              <Text style={styles.progressTitle}>Niveau {user?.level}</Text>
              <Text style={styles.progressXP}>
                {user?.xp % 1000} / 1000 XP
              </Text>
            </View>
            <View style={styles.progressBar}>
              <View
                style={[
                  styles.progressFill,
                  { width: `${progressToNextLevel}%` },
                ]}
              />
            </View>
            <Text style={styles.progressText}>
              {1000 - (user?.xp || 0) % 1000} XP pour le niveau suivant
            </Text>
          </View>
        </View>

        {/* Stats */}
        <View style={styles.section}>
          <Text style={styles.sectionTitle}>Statistiques</Text>
          <View style={styles.statsGrid}>
            <View style={styles.statCard}>
              <Ionicons name="wallet" size={32} color="#10B981" />
              <Text style={styles.statValue}>
                ${user?.virtual_balance?.toFixed(2)}
              </Text>
              <Text style={styles.statLabel}>Solde virtuel</Text>
            </View>
            <View style={styles.statCard}>
              <Ionicons name="trending-up" size={32} color="#3B82F6" />
              <Text style={styles.statValue}>
                ${user?.total_profit?.toFixed(2)}
              </Text>
              <Text style={styles.statLabel}>Profit total</Text>
            </View>
            <View style={styles.statCard}>
              <Ionicons name="star" size={32} color="#F59E0B" />
              <Text style={styles.statValue}>{user?.xp}</Text>
              <Text style={styles.statLabel}>Points XP</Text>
            </View>
            <View style={styles.statCard}>
              <Ionicons name="flash" size={32} color="#8B5CF6" />
              <Text style={styles.statValue}>{user?.level}</Text>
              <Text style={styles.statLabel}>Niveau</Text>
            </View>
          </View>
        </View>

        {/* AI Assistant Button */}
        <View style={styles.section}>
          <TouchableOpacity
            style={styles.aiButton}
            onPress={() => setAiModalVisible(true)}
          >
            <Ionicons name="chatbubbles" size={24} color="#FFFFFF" />
            <Text style={styles.aiButtonText}>Assistant IA Trading</Text>
            <Ionicons name="chevron-forward" size={24} color="#FFFFFF" />
          </TouchableOpacity>
        </View>

        {/* Actions */}
        <View style={styles.section}>
          <Text style={styles.sectionTitle}>Paramètres</Text>
          <TouchableOpacity style={styles.actionButton}>
            <Ionicons name="notifications" size={24} color="#94A3B8" />
            <Text style={styles.actionText}>Notifications</Text>
            <Ionicons name="chevron-forward" size={24} color="#64748B" />
          </TouchableOpacity>
          <TouchableOpacity style={styles.actionButton}>
            <Ionicons name="help-circle" size={24} color="#94A3B8" />
            <Text style={styles.actionText}>Aide & Support</Text>
            <Ionicons name="chevron-forward" size={24} color="#64748B" />
          </TouchableOpacity>
          <TouchableOpacity style={styles.actionButton}>
            <Ionicons name="information-circle" size={24} color="#94A3B8" />
            <Text style={styles.actionText}>À propos</Text>
            <Ionicons name="chevron-forward" size={24} color="#64748B" />
          </TouchableOpacity>
          <TouchableOpacity
            style={[styles.actionButton, styles.logoutButton]}
            onPress={handleLogout}
          >
            <Ionicons name="log-out" size={24} color="#EF4444" />
            <Text style={[styles.actionText, styles.logoutText]}>
              Déconnexion
            </Text>
          </TouchableOpacity>
        </View>
      </ScrollView>

      {/* AI Assistant Modal */}
      <Modal
        visible={aiModalVisible}
        transparent
        animationType="slide"
        onRequestClose={() => setAiModalVisible(false)}
      >
        <View style={styles.modalOverlay}>
          <View style={styles.modalContent}>
            <View style={styles.modalHeader}>
              <View style={styles.modalHeaderContent}>
                <Ionicons name="chatbubbles" size={24} color="#10B981" />
                <Text style={styles.modalTitle}>Assistant IA</Text>
              </View>
              <TouchableOpacity onPress={() => setAiModalVisible(false)}>
                <Ionicons name="close" size={24} color="#94A3B8" />
              </TouchableOpacity>
            </View>

            <ScrollView style={styles.modalBody}>
              <Text style={styles.aiHint}>
                Posez-moi des questions sur le trading, les cryptomonnaies, les
                stratégies d'investissement...
              </Text>

              {aiResponse && (
                <View style={styles.responseContainer}>
                  <View style={styles.responseHeader}>
                    <Ionicons name="bulb" size={20} color="#10B981" />
                    <Text style={styles.responseTitle}>Réponse</Text>
                  </View>
                  <Text style={styles.responseText}>{aiResponse}</Text>
                </View>
              )}

              <View style={styles.inputContainer}>
                <TextInput
                  style={styles.aiInput}
                  placeholder="Votre question..."
                  placeholderTextColor="#64748B"
                  multiline
                  numberOfLines={3}
                  value={aiMessage}
                  onChangeText={setAiMessage}
                />
                <TouchableOpacity
                  style={[
                    styles.sendButton,
                    aiLoading && styles.sendButtonDisabled,
                  ]}
                  onPress={askAI}
                  disabled={aiLoading}
                >
                  {aiLoading ? (
                    <Text style={styles.sendButtonText}>...</Text>
                  ) : (
                    <Ionicons name="send" size={20} color="#FFFFFF" />
                  )}
                </TouchableOpacity>
              </View>
            </ScrollView>
          </View>
        </View>
      </Modal>
    </View>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: '#0F172A',
  },
  header: {
    alignItems: 'center',
    padding: 32,
    paddingTop: 60,
  },
  avatarContainer: {
    position: 'relative',
    marginBottom: 16,
  },
  avatar: {
    width: 100,
    height: 100,
    borderRadius: 50,
    backgroundColor: '#1E293B',
    justifyContent: 'center',
    alignItems: 'center',
    borderWidth: 3,
    borderColor: '#10B981',
  },
  levelBadge: {
    position: 'absolute',
    bottom: 0,
    right: 0,
    width: 32,
    height: 32,
    borderRadius: 16,
    backgroundColor: '#10B981',
    justifyContent: 'center',
    alignItems: 'center',
    borderWidth: 3,
    borderColor: '#0F172A',
  },
  levelText: {
    fontSize: 14,
    fontWeight: 'bold',
    color: '#FFFFFF',
  },
  userName: {
    fontSize: 24,
    fontWeight: 'bold',
    color: '#FFFFFF',
    marginBottom: 4,
  },
  userEmail: {
    fontSize: 16,
    color: '#94A3B8',
  },
  section: {
    padding: 20,
  },
  sectionTitle: {
    fontSize: 18,
    fontWeight: '600',
    color: '#FFFFFF',
    marginBottom: 16,
  },
  progressCard: {
    backgroundColor: '#1E293B',
    borderRadius: 12,
    padding: 20,
    borderWidth: 1,
    borderColor: '#334155',
  },
  progressHeader: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    alignItems: 'center',
    marginBottom: 12,
  },
  progressTitle: {
    fontSize: 18,
    fontWeight: '600',
    color: '#FFFFFF',
  },
  progressXP: {
    fontSize: 14,
    fontWeight: '600',
    color: '#10B981',
  },
  progressBar: {
    height: 8,
    backgroundColor: '#334155',
    borderRadius: 4,
    overflow: 'hidden',
    marginBottom: 12,
  },
  progressFill: {
    height: '100%',
    backgroundColor: '#10B981',
    borderRadius: 4,
  },
  progressText: {
    fontSize: 14,
    color: '#94A3B8',
    textAlign: 'center',
  },
  statsGrid: {
    flexDirection: 'row',
    flexWrap: 'wrap',
    gap: 12,
  },
  statCard: {
    backgroundColor: '#1E293B',
    borderRadius: 12,
    padding: 20,
    alignItems: 'center',
    width: '47%',
    borderWidth: 1,
    borderColor: '#334155',
  },
  statValue: {
    fontSize: 20,
    fontWeight: 'bold',
    color: '#FFFFFF',
    marginTop: 12,
  },
  statLabel: {
    fontSize: 12,
    color: '#94A3B8',
    marginTop: 4,
    textAlign: 'center',
  },
  aiButton: {
    backgroundColor: '#10B981',
    borderRadius: 12,
    padding: 20,
    flexDirection: 'row',
    alignItems: 'center',
    justifyContent: 'space-between',
  },
  aiButtonText: {
    flex: 1,
    fontSize: 18,
    fontWeight: '600',
    color: '#FFFFFF',
    marginLeft: 12,
  },
  actionButton: {
    flexDirection: 'row',
    alignItems: 'center',
    backgroundColor: '#1E293B',
    borderRadius: 12,
    padding: 16,
    marginBottom: 12,
    borderWidth: 1,
    borderColor: '#334155',
  },
  actionText: {
    flex: 1,
    fontSize: 16,
    color: '#FFFFFF',
    marginLeft: 12,
  },
  logoutButton: {
    marginTop: 8,
  },
  logoutText: {
    color: '#EF4444',
  },
  modalOverlay: {
    flex: 1,
    backgroundColor: 'rgba(0, 0, 0, 0.7)',
    justifyContent: 'flex-end',
  },
  modalContent: {
    backgroundColor: '#1E293B',
    borderTopLeftRadius: 24,
    borderTopRightRadius: 24,
    maxHeight: '80%',
  },
  modalHeader: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    alignItems: 'center',
    padding: 20,
    borderBottomWidth: 1,
    borderBottomColor: '#334155',
  },
  modalHeaderContent: {
    flexDirection: 'row',
    alignItems: 'center',
  },
  modalTitle: {
    fontSize: 20,
    fontWeight: 'bold',
    color: '#FFFFFF',
    marginLeft: 12,
  },
  modalBody: {
    padding: 20,
  },
  aiHint: {
    fontSize: 14,
    color: '#94A3B8',
    marginBottom: 20,
    lineHeight: 20,
  },
  responseContainer: {
    backgroundColor: '#0F172A',
    borderRadius: 12,
    padding: 16,
    marginBottom: 20,
    borderWidth: 1,
    borderColor: '#10B981',
  },
  responseHeader: {
    flexDirection: 'row',
    alignItems: 'center',
    marginBottom: 12,
  },
  responseTitle: {
    fontSize: 16,
    fontWeight: '600',
    color: '#10B981',
    marginLeft: 8,
  },
  responseText: {
    fontSize: 14,
    color: '#FFFFFF',
    lineHeight: 22,
  },
  inputContainer: {
    flexDirection: 'row',
    gap: 12,
  },
  aiInput: {
    flex: 1,
    backgroundColor: '#0F172A',
    borderRadius: 12,
    padding: 16,
    fontSize: 16,
    color: '#FFFFFF',
    borderWidth: 1,
    borderColor: '#334155',
    minHeight: 80,
    textAlignVertical: 'top',
  },
  sendButton: {
    width: 56,
    height: 56,
    borderRadius: 28,
    backgroundColor: '#10B981',
    justifyContent: 'center',
    alignItems: 'center',
  },
  sendButtonDisabled: {
    opacity: 0.6,
  },
  sendButtonText: {
    color: '#FFFFFF',
    fontSize: 18,
    fontWeight: 'bold',
  },
});
