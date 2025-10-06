import React, { useEffect, useState } from 'react';
import {
  View,
  Text,
  StyleSheet,
  ScrollView,
  TouchableOpacity,
  TextInput,
  Alert,
  ActivityIndicator,
  Modal,
} from 'react-native';
import { Ionicons } from '@expo/vector-icons';
import { useAuthStore } from '../../store/authStore';
import { marketAPI, tradingAPI, authAPI } from '../../services/api';

export default function TradingScreen() {
  const user = useAuthStore((state) => state.user);
  const updateUser = useAuthStore((state) => state.updateUser);
  const [cryptoPrices, setCryptoPrices] = useState<any[]>([]);
  const [portfolio, setPortfolio] = useState<any[]>([]);
  const [transactions, setTransactions] = useState<any[]>([]);
  const [loading, setLoading] = useState(true);
  const [tradeModalVisible, setTradeModalVisible] = useState(false);
  const [selectedAsset, setSelectedAsset] = useState<any>(null);
  const [tradeType, setTradeType] = useState<'buy' | 'sell'>('buy');
  const [quantity, setQuantity] = useState('');
  const [activeTab, setActiveTab] = useState<'market' | 'portfolio'>('market');

  useEffect(() => {
    loadData();
    const interval = setInterval(loadData, 15000);
    return () => clearInterval(interval);
  }, []);

  const loadData = async () => {
    try {
      const [pricesRes, portfolioRes, transactionsRes] = await Promise.all([
        marketAPI.getCryptoPrices(),
        tradingAPI.getPortfolio(user?.id || ''),
        tradingAPI.getTransactions(user?.id || ''),
      ]);
      
      setCryptoPrices(pricesRes.data.data || []);
      setPortfolio(portfolioRes.data.positions || []);
      setTransactions(transactionsRes.data.transactions || []);
    } catch (error) {
      console.error('Error loading trading data:', error);
    } finally {
      setLoading(false);
    }
  };

  const openTradeModal = (asset: any, type: 'buy' | 'sell') => {
    setSelectedAsset(asset);
    setTradeType(type);
    setQuantity('');
    setTradeModalVisible(true);
  };

  const executeTrade = async () => {
    if (!quantity || parseFloat(quantity) <= 0) {
      Alert.alert('Erreur', 'Quantité invalide');
      return;
    }

    const qty = parseFloat(quantity);
    const price = selectedAsset.price || selectedAsset.current_price;
    const total = qty * price;

    if (tradeType === 'buy' && total > (user?.virtual_balance || 0)) {
      Alert.alert('Erreur', 'Solde insuffisant');
      return;
    }

    try {
      await tradingAPI.executeTrade({
        user_id: user?.id,
        symbol: selectedAsset.symbol,
        asset_type: 'crypto',
        transaction_type: tradeType,
        quantity: qty,
        price: price,
      });

      // Refresh user data and portfolio
      const userRes = await authAPI.getUser(user?.id || '');
      updateUser(userRes.data);
      await loadData();

      Alert.alert(
        'Succès',
        `${tradeType === 'buy' ? 'Achat' : 'Vente'} exécuté avec succès!`
      );
      setTradeModalVisible(false);
    } catch (error: any) {
      Alert.alert('Erreur', error.response?.data?.detail || 'Erreur lors de la transaction');
    }
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
      {/* Header with Balance */}
      <View style={styles.header}>
        <Text style={styles.title}>Trading</Text>
        <View style={styles.balanceCard}>
          <Text style={styles.balanceLabel}>Solde disponible</Text>
          <Text style={styles.balanceAmount}>${user?.virtual_balance?.toFixed(2)}</Text>
        </View>
      </View>

      {/* Tabs */}
      <View style={styles.tabs}>
        <TouchableOpacity
          style={[styles.tab, activeTab === 'market' && styles.activeTab]}
          onPress={() => setActiveTab('market')}
        >
          <Text style={[styles.tabText, activeTab === 'market' && styles.activeTabText]}>
            Marché
          </Text>
        </TouchableOpacity>
        <TouchableOpacity
          style={[styles.tab, activeTab === 'portfolio' && styles.activeTab]}
          onPress={() => setActiveTab('portfolio')}
        >
          <Text style={[styles.tabText, activeTab === 'portfolio' && styles.activeTabText]}>
            Portefeuille
          </Text>
        </TouchableOpacity>
      </View>

      <ScrollView style={styles.content}>
        {activeTab === 'market' ? (
          // Market View
          <View style={styles.section}>
            {cryptoPrices.map((crypto) => (
              <View key={crypto.symbol} style={styles.assetCard}>
                <View style={styles.assetInfo}>
                  <Text style={styles.assetSymbol}>{crypto.symbol}</Text>
                  <Text style={styles.assetName}>{crypto.name}</Text>
                  <View style={styles.priceRow}>
                    <Text style={styles.assetPrice}>${crypto.price?.toFixed(2)}</Text>
                    <Text
                      style={[
                        styles.assetChange,
                        crypto.change_24h >= 0 ? styles.positive : styles.negative,
                      ]}
                    >
                      {crypto.change_24h >= 0 ? '+' : ''}
                      {crypto.change_24h?.toFixed(2)}%
                    </Text>
                  </View>
                </View>
                <View style={styles.tradeButtons}>
                  <TouchableOpacity
                    style={[styles.tradeButton, styles.buyButton]}
                    onPress={() => openTradeModal(crypto, 'buy')}
                  >
                    <Text style={styles.tradeButtonText}>Acheter</Text>
                  </TouchableOpacity>
                </View>
              </View>
            ))}
          </View>
        ) : (
          // Portfolio View
          <View style={styles.section}>
            {portfolio.length > 0 ? (
              portfolio.map((position) => {
                const currentPrice = cryptoPrices.find(
                  (c) => c.symbol === position.symbol
                )?.price || position.buy_price;
                const currentValue = position.quantity * currentPrice;
                const profitLoss = currentValue - (position.quantity * position.buy_price);
                const profitLossPercent = (profitLoss / (position.quantity * position.buy_price)) * 100;

                return (
                  <View key={position.id} style={styles.positionCard}>
                    <View style={styles.positionHeader}>
                      <View>
                        <Text style={styles.positionSymbol}>{position.symbol}</Text>
                        <Text style={styles.positionQuantity}>
                          {position.quantity} unités
                        </Text>
                      </View>
                      <TouchableOpacity
                        style={[styles.tradeButton, styles.sellButton]}
                        onPress={() => openTradeModal({...position, price: currentPrice}, 'sell')}
                      >
                        <Text style={styles.tradeButtonText}>Vendre</Text>
                      </TouchableOpacity>
                    </View>
                    <View style={styles.positionDetails}>
                      <View style={styles.positionRow}>
                        <Text style={styles.positionLabel}>Prix d'achat:</Text>
                        <Text style={styles.positionValue}>
                          ${position.buy_price?.toFixed(2)}
                        </Text>
                      </View>
                      <View style={styles.positionRow}>
                        <Text style={styles.positionLabel}>Prix actuel:</Text>
                        <Text style={styles.positionValue}>
                          ${currentPrice?.toFixed(2)}
                        </Text>
                      </View>
                      <View style={styles.positionRow}>
                        <Text style={styles.positionLabel}>Valeur:</Text>
                        <Text style={styles.positionValue}>
                          ${currentValue?.toFixed(2)}
                        </Text>
                      </View>
                      <View style={styles.positionRow}>
                        <Text style={styles.positionLabel}>P&L:</Text>
                        <Text
                          style={[
                            styles.profitLoss,
                            profitLoss >= 0 ? styles.positive : styles.negative,
                          ]}
                        >
                          ${profitLoss?.toFixed(2)} ({profitLossPercent?.toFixed(2)}%)
                        </Text>
                      </View>
                    </View>
                  </View>
                );
              })
            ) : (
              <View style={styles.emptyState}>
                <Ionicons name="briefcase-outline" size={64} color="#64748B" />
                <Text style={styles.emptyText}>Votre portefeuille est vide</Text>
                <Text style={styles.emptySubtext}>
                  Commencez à trader pour voir vos positions ici
                </Text>
              </View>
            )}

            {transactions.length > 0 && (
              <View style={styles.transactionsSection}>
                <Text style={styles.sectionTitle}>Historique</Text>
                {transactions.slice(0, 10).map((tx) => (
                  <View key={tx.id} style={styles.transactionCard}>
                    <View style={styles.transactionIcon}>
                      <Ionicons
                        name={tx.transaction_type === 'buy' ? 'arrow-down' : 'arrow-up'}
                        size={20}
                        color={tx.transaction_type === 'buy' ? '#10B981' : '#EF4444'}
                      />
                    </View>
                    <View style={styles.transactionInfo}>
                      <Text style={styles.transactionSymbol}>{tx.symbol}</Text>
                      <Text style={styles.transactionTime}>
                        {new Date(tx.timestamp).toLocaleDateString('fr-FR')}
                      </Text>
                    </View>
                    <View style={styles.transactionDetails}>
                      <Text style={styles.transactionQuantity}>
                        {tx.quantity} @ ${tx.price?.toFixed(2)}
                      </Text>
                      <Text
                        style={[
                          styles.transactionTotal,
                          tx.transaction_type === 'buy' ? styles.negative : styles.positive,
                        ]}
                      >
                        ${tx.total?.toFixed(2)}
                      </Text>
                    </View>
                  </View>
                ))}
              </View>
            )}
          </View>
        )}
      </ScrollView>

      {/* Trade Modal */}
      <Modal
        visible={tradeModalVisible}
        transparent
        animationType="slide"
        onRequestClose={() => setTradeModalVisible(false)}
      >
        <View style={styles.modalOverlay}>
          <View style={styles.modalContent}>
            <View style={styles.modalHeader}>
              <Text style={styles.modalTitle}>
                {tradeType === 'buy' ? 'Acheter' : 'Vendre'} {selectedAsset?.symbol}
              </Text>
              <TouchableOpacity onPress={() => setTradeModalVisible(false)}>
                <Ionicons name="close" size={24} color="#94A3B8" />
              </TouchableOpacity>
            </View>

            <View style={styles.modalBody}>
              <Text style={styles.modalLabel}>Prix actuel</Text>
              <Text style={styles.modalPrice}>
                ${(selectedAsset?.price || selectedAsset?.current_price)?.toFixed(2)}
              </Text>

              <Text style={styles.modalLabel}>Quantité</Text>
              <TextInput
                style={styles.modalInput}
                placeholder="0.00"
                placeholderTextColor="#64748B"
                keyboardType="numeric"
                value={quantity}
                onChangeText={setQuantity}
              />

              {quantity && (
                <View style={styles.totalContainer}>
                  <Text style={styles.totalLabel}>Total</Text>
                  <Text style={styles.totalValue}>
                    ${(parseFloat(quantity) * (selectedAsset?.price || selectedAsset?.current_price || 0)).toFixed(2)}
                  </Text>
                </View>
              )}

              <TouchableOpacity
                style={[
                  styles.executeButton,
                  tradeType === 'buy' ? styles.buyButton : styles.sellButton,
                ]}
                onPress={executeTrade}
              >
                <Text style={styles.executeButtonText}>
                  {tradeType === 'buy' ? 'Acheter' : 'Vendre'}
                </Text>
              </TouchableOpacity>
            </View>
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
    marginBottom: 16,
  },
  balanceCard: {
    backgroundColor: '#1E293B',
    borderRadius: 12,
    padding: 16,
    borderWidth: 1,
    borderColor: '#334155',
  },
  balanceLabel: {
    fontSize: 14,
    color: '#94A3B8',
  },
  balanceAmount: {
    fontSize: 28,
    fontWeight: 'bold',
    color: '#10B981',
    marginTop: 4,
  },
  tabs: {
    flexDirection: 'row',
    paddingHorizontal: 20,
    marginBottom: 16,
  },
  tab: {
    flex: 1,
    paddingVertical: 12,
    alignItems: 'center',
    borderBottomWidth: 2,
    borderBottomColor: 'transparent',
  },
  activeTab: {
    borderBottomColor: '#10B981',
  },
  tabText: {
    fontSize: 16,
    fontWeight: '600',
    color: '#64748B',
  },
  activeTabText: {
    color: '#10B981',
  },
  content: {
    flex: 1,
  },
  section: {
    padding: 20,
  },
  assetCard: {
    backgroundColor: '#1E293B',
    borderRadius: 12,
    padding: 16,
    marginBottom: 12,
    flexDirection: 'row',
    justifyContent: 'space-between',
    alignItems: 'center',
    borderWidth: 1,
    borderColor: '#334155',
  },
  assetInfo: {
    flex: 1,
  },
  assetSymbol: {
    fontSize: 18,
    fontWeight: 'bold',
    color: '#FFFFFF',
  },
  assetName: {
    fontSize: 14,
    color: '#94A3B8',
    marginTop: 2,
  },
  priceRow: {
    flexDirection: 'row',
    alignItems: 'center',
    marginTop: 8,
  },
  assetPrice: {
    fontSize: 16,
    fontWeight: '600',
    color: '#FFFFFF',
    marginRight: 8,
  },
  assetChange: {
    fontSize: 14,
    fontWeight: '600',
  },
  positive: {
    color: '#10B981',
  },
  negative: {
    color: '#EF4444',
  },
  tradeButtons: {
    flexDirection: 'row',
    gap: 8,
  },
  tradeButton: {
    paddingHorizontal: 20,
    paddingVertical: 10,
    borderRadius: 8,
  },
  buyButton: {
    backgroundColor: '#10B981',
  },
  sellButton: {
    backgroundColor: '#EF4444',
  },
  tradeButtonText: {
    color: '#FFFFFF',
    fontWeight: '600',
    fontSize: 14,
  },
  positionCard: {
    backgroundColor: '#1E293B',
    borderRadius: 12,
    padding: 16,
    marginBottom: 12,
    borderWidth: 1,
    borderColor: '#334155',
  },
  positionHeader: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    alignItems: 'center',
    marginBottom: 16,
  },
  positionSymbol: {
    fontSize: 20,
    fontWeight: 'bold',
    color: '#FFFFFF',
  },
  positionQuantity: {
    fontSize: 14,
    color: '#94A3B8',
    marginTop: 4,
  },
  positionDetails: {
    gap: 8,
  },
  positionRow: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    alignItems: 'center',
  },
  positionLabel: {
    fontSize: 14,
    color: '#94A3B8',
  },
  positionValue: {
    fontSize: 14,
    fontWeight: '600',
    color: '#FFFFFF',
  },
  profitLoss: {
    fontSize: 14,
    fontWeight: '600',
  },
  emptyState: {
    alignItems: 'center',
    justifyContent: 'center',
    paddingVertical: 60,
  },
  emptyText: {
    fontSize: 18,
    fontWeight: '600',
    color: '#FFFFFF',
    marginTop: 16,
  },
  emptySubtext: {
    fontSize: 14,
    color: '#64748B',
    marginTop: 8,
    textAlign: 'center',
  },
  transactionsSection: {
    marginTop: 32,
  },
  sectionTitle: {
    fontSize: 18,
    fontWeight: '600',
    color: '#FFFFFF',
    marginBottom: 16,
  },
  transactionCard: {
    backgroundColor: '#1E293B',
    borderRadius: 12,
    padding: 12,
    marginBottom: 8,
    flexDirection: 'row',
    alignItems: 'center',
    borderWidth: 1,
    borderColor: '#334155',
  },
  transactionIcon: {
    width: 40,
    height: 40,
    borderRadius: 20,
    backgroundColor: '#0F172A',
    justifyContent: 'center',
    alignItems: 'center',
    marginRight: 12,
  },
  transactionInfo: {
    flex: 1,
  },
  transactionSymbol: {
    fontSize: 16,
    fontWeight: '600',
    color: '#FFFFFF',
  },
  transactionTime: {
    fontSize: 12,
    color: '#64748B',
    marginTop: 2,
  },
  transactionDetails: {
    alignItems: 'flex-end',
  },
  transactionQuantity: {
    fontSize: 14,
    color: '#94A3B8',
  },
  transactionTotal: {
    fontSize: 16,
    fontWeight: '600',
    marginTop: 2,
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
    paddingBottom: 40,
  },
  modalHeader: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    alignItems: 'center',
    padding: 20,
    borderBottomWidth: 1,
    borderBottomColor: '#334155',
  },
  modalTitle: {
    fontSize: 20,
    fontWeight: 'bold',
    color: '#FFFFFF',
  },
  modalBody: {
    padding: 20,
  },
  modalLabel: {
    fontSize: 14,
    color: '#94A3B8',
    marginBottom: 8,
  },
  modalPrice: {
    fontSize: 28,
    fontWeight: 'bold',
    color: '#FFFFFF',
    marginBottom: 24,
  },
  modalInput: {
    backgroundColor: '#0F172A',
    borderRadius: 12,
    padding: 16,
    fontSize: 18,
    color: '#FFFFFF',
    borderWidth: 1,
    borderColor: '#334155',
    marginBottom: 16,
  },
  totalContainer: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    alignItems: 'center',
    padding: 16,
    backgroundColor: '#0F172A',
    borderRadius: 12,
    marginBottom: 24,
  },
  totalLabel: {
    fontSize: 16,
    color: '#94A3B8',
  },
  totalValue: {
    fontSize: 24,
    fontWeight: 'bold',
    color: '#FFFFFF',
  },
  executeButton: {
    padding: 16,
    borderRadius: 12,
    alignItems: 'center',
  },
  executeButtonText: {
    fontSize: 18,
    fontWeight: '600',
    color: '#FFFFFF',
  },
});
