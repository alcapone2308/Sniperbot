import React, { useEffect, useState } from 'react';
import {
  View,
  Text,
  StyleSheet,
  ScrollView,
  ActivityIndicator,
  RefreshControl,
} from 'react-native';
import { Ionicons } from '@expo/vector-icons';
import { leaderboardAPI } from '../../services/api';
import { useAuthStore } from '../../store/authStore';

export default function LeaderboardScreen() {
  const user = useAuthStore((state) => state.user);
  const [leaderboard, setLeaderboard] = useState<any[]>([]);
  const [loading, setLoading] = useState(true);
  const [refreshing, setRefreshing] = useState(false);

  useEffect(() => {
    loadLeaderboard();
  }, []);

  const loadLeaderboard = async () => {
    try {
      const response = await leaderboardAPI.getLeaderboard();
      setLeaderboard(response.data.leaderboard || []);
    } catch (error) {
      console.error('Error loading leaderboard:', error);
    } finally {
      setLoading(false);
      setRefreshing(false);
    }
  };

  const onRefresh = () => {
    setRefreshing(true);
    loadLeaderboard();
  };

  const getRankColor = (rank: number) => {
    if (rank === 1) return '#FFD700';
    if (rank === 2) return '#C0C0C0';
    if (rank === 3) return '#CD7F32';
    return '#64748B';
  };

  const getRankIcon = (rank: number) => {
    if (rank === 1) return 'trophy';
    if (rank === 2) return 'medal';
    if (rank === 3) return 'medal';
    return 'ribbon';
  };

  if (loading) {
    return (
      <View style={styles.loadingContainer}>
        <ActivityIndicator size="large" color="#10B981" />
      </View>
    );
  }

  return (
    <View style={styles.container}>
      <View style={styles.header}>
        <Text style={styles.title}>Classement</Text>
        <Text style={styles.subtitle}>Top traders de la communauté</Text>
      </View>

      <ScrollView
        style={styles.content}
        refreshControl={
          <RefreshControl
            refreshing={refreshing}
            onRefresh={onRefresh}
            tintColor="#10B981"
          />
        }
      >
        {/* Top 3 Podium */}
        {leaderboard.length >= 3 && (
          <View style={styles.podium}>
            {/* 2nd Place */}
            <View style={styles.podiumPosition}>
              <View style={[styles.podiumRank, { backgroundColor: '#475569' }]}>
                <Ionicons name="medal" size={32} color="#C0C0C0" />
              </View>
              <Text style={styles.podiumName} numberOfLines={1}>
                {leaderboard[1].name}
              </Text>
              <Text style={styles.podiumProfit}>
                ${leaderboard[1].total_profit?.toFixed(2)}
              </Text>
            </View>

            {/* 1st Place */}
            <View style={[styles.podiumPosition, styles.firstPlace]}>
              <View style={[styles.podiumRank, { backgroundColor: '#78350F' }]}>
                <Ionicons name="trophy" size={40} color="#FFD700" />
              </View>
              <Text style={[styles.podiumName, styles.firstPlaceName]} numberOfLines={1}>
                {leaderboard[0].name}
              </Text>
              <Text style={[styles.podiumProfit, styles.firstPlaceProfit]}>
                ${leaderboard[0].total_profit?.toFixed(2)}
              </Text>
            </View>

            {/* 3rd Place */}
            <View style={styles.podiumPosition}>
              <View style={[styles.podiumRank, { backgroundColor: '#475569' }]}>
                <Ionicons name="medal" size={32} color="#CD7F32" />
              </View>
              <Text style={styles.podiumName} numberOfLines={1}>
                {leaderboard[2].name}
              </Text>
              <Text style={styles.podiumProfit}>
                ${leaderboard[2].total_profit?.toFixed(2)}
              </Text>
            </View>
          </View>
        )}

        {/* Leaderboard List */}
        <View style={styles.listSection}>
          {leaderboard.map((entry, index) => {
            const isCurrentUser = entry.name === user?.name;
            return (
              <View
                key={index}
                style={[
                  styles.leaderboardCard,
                  isCurrentUser && styles.currentUserCard,
                ]}
              >
                <View style={styles.rankContainer}>
                  <View
                    style={[
                      styles.rankBadge,
                      { backgroundColor: getRankColor(entry.rank) + '20' },
                    ]}
                  >
                    <Ionicons
                      name={getRankIcon(entry.rank)}
                      size={20}
                      color={getRankColor(entry.rank)}
                    />
                  </View>
                  <Text
                    style={[
                      styles.rankNumber,
                      { color: getRankColor(entry.rank) },
                    ]}
                  >
                    #{entry.rank}
                  </Text>
                </View>

                <View style={styles.userInfo}>
                  <Text style={[styles.userName, isCurrentUser && styles.currentUserText]}>
                    {entry.name}
                    {isCurrentUser && ' (Vous)'}
                  </Text>
                  <View style={styles.statsRow}>
                    <View style={styles.stat}>
                      <Ionicons name="trending-up" size={14} color="#64748B" />
                      <Text style={styles.statText}>Niveau {entry.level}</Text>
                    </View>
                    <View style={styles.stat}>
                      <Ionicons name="star" size={14} color="#F59E0B" />
                      <Text style={styles.statText}>{entry.xp} XP</Text>
                    </View>
                  </View>
                </View>

                <View style={styles.profitContainer}>
                  <Text
                    style={[
                      styles.profitAmount,
                      entry.total_profit >= 0 ? styles.positive : styles.negative,
                    ]}
                  >
                    ${entry.total_profit?.toFixed(2)}
                  </Text>
                  <Text style={styles.profitLabel}>Profit</Text>
                </View>
              </View>
            );
          })}
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
  content: {
    flex: 1,
  },
  podium: {
    flexDirection: 'row',
    justifyContent: 'center',
    alignItems: 'flex-end',
    paddingHorizontal: 20,
    marginBottom: 32,
  },
  podiumPosition: {
    flex: 1,
    alignItems: 'center',
    marginHorizontal: 4,
  },
  firstPlace: {
    marginBottom: 16,
  },
  podiumRank: {
    width: 72,
    height: 72,
    borderRadius: 36,
    justifyContent: 'center',
    alignItems: 'center',
    marginBottom: 12,
  },
  podiumName: {
    fontSize: 14,
    fontWeight: '600',
    color: '#FFFFFF',
    marginBottom: 4,
    textAlign: 'center',
  },
  firstPlaceName: {
    fontSize: 16,
  },
  podiumProfit: {
    fontSize: 14,
    fontWeight: '600',
    color: '#10B981',
  },
  firstPlaceProfit: {
    fontSize: 16,
  },
  listSection: {
    padding: 20,
  },
  leaderboardCard: {
    backgroundColor: '#1E293B',
    borderRadius: 12,
    padding: 16,
    flexDirection: 'row',
    alignItems: 'center',
    marginBottom: 12,
    borderWidth: 1,
    borderColor: '#334155',
  },
  currentUserCard: {
    borderColor: '#10B981',
    borderWidth: 2,
  },
  rankContainer: {
    alignItems: 'center',
    marginRight: 16,
  },
  rankBadge: {
    width: 44,
    height: 44,
    borderRadius: 22,
    justifyContent: 'center',
    alignItems: 'center',
    marginBottom: 4,
  },
  rankNumber: {
    fontSize: 14,
    fontWeight: 'bold',
  },
  userInfo: {
    flex: 1,
  },
  userName: {
    fontSize: 16,
    fontWeight: '600',
    color: '#FFFFFF',
    marginBottom: 8,
  },
  currentUserText: {
    color: '#10B981',
  },
  statsRow: {
    flexDirection: 'row',
    gap: 12,
  },
  stat: {
    flexDirection: 'row',
    alignItems: 'center',
    gap: 4,
  },
  statText: {
    fontSize: 12,
    color: '#64748B',
  },
  profitContainer: {
    alignItems: 'flex-end',
  },
  profitAmount: {
    fontSize: 18,
    fontWeight: 'bold',
    marginBottom: 2,
  },
  profitLabel: {
    fontSize: 12,
    color: '#64748B',
  },
  positive: {
    color: '#10B981',
  },
  negative: {
    color: '#EF4444',
  },
});
