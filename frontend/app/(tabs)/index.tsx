import React, { useEffect, useState, useRef } from 'react';
import {
  View,
  Text,
  StyleSheet,
  ScrollView,
  TouchableOpacity,
  ActivityIndicator,
  Animated,
  Dimensions,
  RefreshControl,
} from 'react-native';
import { Ionicons } from '@expo/vector-icons';
import { useAuthStore } from '../../store/authStore';
import { marketAPI, challengesAPI } from '../../services/api';

const { width } = Dimensions.get('window');

export default function HomeScreen() {
  const user = useAuthStore((state) => state.user);
  const [news, setNews] = useState<any[]>([]);
  const [cryptoPrices, setCryptoPrices] = useState<any[]>([]);
  const [challenges, setChallenges] = useState<any[]>([]);
  const [loading, setLoading] = useState(true);
  const [refreshing, setRefreshing] = useState(false);
  const scrollX = useRef(new Animated.Value(0)).current;

  const loadData = async () => {
    try {
      const [newsRes, pricesRes, challengesRes] = await Promise.all([
        marketAPI.getNews(),
        marketAPI.getCryptoPrices(),
        challengesAPI.getDailyChallenges(),
      ]);
      
      setNews(newsRes.data.news || []);
      setCryptoPrices(pricesRes.data.data || []);
      setChallenges(challengesRes.data.challenges || []);
    } catch (error) {
      console.error('Error loading data:', error);
    } finally {
      setLoading(false);
      setRefreshing(false);
    }
  };

  useEffect(() => {
    loadData();
    // Auto-refresh every 30 seconds
    const interval = setInterval(() => {
      loadData();
    }, 30000);
    return () => clearInterval(interval);
  }, []);

  const onRefresh = () => {
    setRefreshing(true);
    loadData();
  };

  if (loading) {
    return (
      <View style={styles.loadingContainer}>
        <ActivityIndicator size="large" color="#10B981" />
      </View>
    );
  }

  return (
    <ScrollView
      style={styles.container}
      refreshControl={
        <RefreshControl
          refreshing={refreshing}
          onRefresh={onRefresh}
          tintColor="#10B981"
        />
      }
    >
      {/* Header with user info */}
      <View style={styles.header}>
        <View>
          <Text style={styles.greeting}>Bonjour,</Text>
          <Text style={styles.userName}>{user?.name}</Text>
        </View>
        <View style={styles.balanceContainer}>
          <Text style={styles.balanceLabel}>Solde virtuel</Text>
          <Text style={styles.balanceAmount}>
            ${user?.virtual_balance?.toFixed(2)}
          </Text>
        </View>
      </View>

      {/* News Ticker */}
      <View style={styles.newsSection}>
        <View style={styles.sectionHeader}>
          <Ionicons name="newspaper" size={20} color="#10B981" />
          <Text style={styles.sectionTitle}>Actualités économiques</Text>
        </View>
        <ScrollView
          horizontal
          showsHorizontalScrollIndicator={false}
          onScroll={Animated.event(
            [{ nativeEvent: { contentOffset: { x: scrollX } } }],
            { useNativeDriver: false }
          )}
          scrollEventThrottle={16}
        >
          {news.map((item, index) => (
            <View key={item.id} style={styles.newsCard}>
              <Ionicons name="flash" size={16} color="#F59E0B" />
              <View style={styles.newsContent}>
                <Text style={styles.newsTitle} numberOfLines={2}>
                  {item.title}
                </Text>
                <Text style={styles.newsSource}>{item.source}</Text>
              </View>
            </View>
          ))}
        </ScrollView>
      </View>

      {/* Stats Cards */}
      <View style={styles.statsContainer}>
        <View style={[styles.statCard, { backgroundColor: '#1E3A8A' }]}>
          <Ionicons name="trending-up" size={32} color="#60A5FA" />
          <Text style={styles.statValue}>Niveau {user?.level}</Text>
          <Text style={styles.statLabel}>{user?.xp} XP</Text>
        </View>
        <View style={[styles.statCard, { backgroundColor: '#065F46' }]}>
          <Ionicons name="cash" size={32} color="#34D399" />
          <Text style={styles.statValue}>
            ${user?.total_profit?.toFixed(2)}
          </Text>
          <Text style={styles.statLabel}>Profit total</Text>
        </View>
      </View>

      {/* Daily Challenges */}
      <View style={styles.section}>
        <View style={styles.sectionHeader}>
          <Ionicons name="trophy" size={20} color="#F59E0B" />
          <Text style={styles.sectionTitle}>Défis du jour</Text>
        </View>
        {challenges.length > 0 ? (
          challenges.map((challenge) => (
            <View key={challenge.id} style={styles.challengeCard}>
              <View style={styles.challengeIcon}>
                <Ionicons name="star" size={24} color="#F59E0B" />
              </View>
              <View style={styles.challengeContent}>
                <Text style={styles.challengeTitle}>{challenge.title}</Text>
                <Text style={styles.challengeDescription}>
                  {challenge.description}
                </Text>
                <View style={styles.challengeReward}>
                  <Ionicons name="trophy" size={14} color="#F59E0B" />
                  <Text style={styles.rewardText}>
                    +{challenge.xp_reward} XP
                  </Text>
                </View>
              </View>
            </View>
          ))
        ) : (
          <Text style={styles.emptyText}>Aucun défi disponible</Text>
        )}
      </View>

      {/* Crypto Prices */}
      <View style={styles.section}>
        <View style={styles.sectionHeader}>
          <Ionicons name="logo-bitcoin" size={20} color="#F7931A" />
          <Text style={styles.sectionTitle}>Marché Crypto</Text>
        </View>
        {cryptoPrices.slice(0, 5).map((crypto) => (
          <View key={crypto.symbol} style={styles.cryptoCard}>
            <View style={styles.cryptoInfo}>
              <Text style={styles.cryptoSymbol}>{crypto.symbol}</Text>
              <Text style={styles.cryptoName}>{crypto.name}</Text>
            </View>
            <View style={styles.cryptoPrice}>
              <Text style={styles.priceText}>${crypto.price?.toFixed(2)}</Text>
              <Text
                style={[
                  styles.changeText,
                  crypto.change_24h >= 0 ? styles.positive : styles.negative,
                ]}
              >
                {crypto.change_24h >= 0 ? '+' : ''}
                {crypto.change_24h?.toFixed(2)}%
              </Text>
            </View>
          </View>
        ))}
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
    flexDirection: 'row',
    justifyContent: 'space-between',
    alignItems: 'flex-start',
    padding: 20,
    paddingTop: 60,
  },
  greeting: {
    fontSize: 16,
    color: '#94A3B8',
  },
  userName: {
    fontSize: 24,
    fontWeight: 'bold',
    color: '#FFFFFF',
    marginTop: 4,
  },
  balanceContainer: {
    backgroundColor: '#1E293B',
    padding: 12,
    borderRadius: 12,
    alignItems: 'flex-end',
  },
  balanceLabel: {
    fontSize: 12,
    color: '#94A3B8',
  },
  balanceAmount: {
    fontSize: 20,
    fontWeight: 'bold',
    color: '#10B981',
    marginTop: 4,
  },
  newsSection: {
    marginBottom: 24,
  },
  section: {
    padding: 20,
  },
  sectionHeader: {
    flexDirection: 'row',
    alignItems: 'center',
    marginBottom: 16,
    paddingHorizontal: 20,
  },
  sectionTitle: {
    fontSize: 18,
    fontWeight: '600',
    color: '#FFFFFF',
    marginLeft: 8,
  },
  newsCard: {
    backgroundColor: '#1E293B',
    borderRadius: 12,
    padding: 16,
    marginLeft: 20,
    width: width * 0.75,
    flexDirection: 'row',
    borderWidth: 1,
    borderColor: '#334155',
  },
  newsContent: {
    flex: 1,
    marginLeft: 12,
  },
  newsTitle: {
    fontSize: 14,
    fontWeight: '600',
    color: '#FFFFFF',
    marginBottom: 4,
  },
  newsSource: {
    fontSize: 12,
    color: '#64748B',
  },
  statsContainer: {
    flexDirection: 'row',
    paddingHorizontal: 20,
    gap: 12,
    marginBottom: 24,
  },
  statCard: {
    flex: 1,
    borderRadius: 16,
    padding: 20,
    alignItems: 'center',
  },
  statValue: {
    fontSize: 24,
    fontWeight: 'bold',
    color: '#FFFFFF',
    marginTop: 12,
  },
  statLabel: {
    fontSize: 14,
    color: '#D1D5DB',
    marginTop: 4,
  },
  challengeCard: {
    backgroundColor: '#1E293B',
    borderRadius: 12,
    padding: 16,
    flexDirection: 'row',
    marginBottom: 12,
    borderWidth: 1,
    borderColor: '#334155',
  },
  challengeIcon: {
    width: 48,
    height: 48,
    borderRadius: 24,
    backgroundColor: '#78350F',
    justifyContent: 'center',
    alignItems: 'center',
    marginRight: 12,
  },
  challengeContent: {
    flex: 1,
  },
  challengeTitle: {
    fontSize: 16,
    fontWeight: '600',
    color: '#FFFFFF',
    marginBottom: 4,
  },
  challengeDescription: {
    fontSize: 14,
    color: '#94A3B8',
    marginBottom: 8,
  },
  challengeReward: {
    flexDirection: 'row',
    alignItems: 'center',
  },
  rewardText: {
    fontSize: 12,
    fontWeight: '600',
    color: '#F59E0B',
    marginLeft: 4,
  },
  cryptoCard: {
    backgroundColor: '#1E293B',
    borderRadius: 12,
    padding: 16,
    flexDirection: 'row',
    justifyContent: 'space-between',
    alignItems: 'center',
    marginBottom: 12,
    borderWidth: 1,
    borderColor: '#334155',
  },
  cryptoInfo: {
    flex: 1,
  },
  cryptoSymbol: {
    fontSize: 18,
    fontWeight: 'bold',
    color: '#FFFFFF',
  },
  cryptoName: {
    fontSize: 14,
    color: '#94A3B8',
    marginTop: 2,
  },
  cryptoPrice: {
    alignItems: 'flex-end',
  },
  priceText: {
    fontSize: 18,
    fontWeight: '600',
    color: '#FFFFFF',
  },
  changeText: {
    fontSize: 14,
    fontWeight: '600',
    marginTop: 2,
  },
  positive: {
    color: '#10B981',
  },
  negative: {
    color: '#EF4444',
  },
  emptyText: {
    color: '#64748B',
    fontSize: 14,
    textAlign: 'center',
    marginTop: 20,
  },
});
