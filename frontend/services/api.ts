import axios from 'axios';
import Constants from 'expo-constants';

const API_URL = Constants.expoConfig?.extra?.EXPO_PUBLIC_BACKEND_URL || process.env.EXPO_PUBLIC_BACKEND_URL || 'http://localhost:8001';

const api = axios.create({
  baseURL: `${API_URL}/api`,
  timeout: 30000,
  headers: {
    'Content-Type': 'application/json',
  },
});

export const authAPI = {
  login: (email: string, name: string, avatar?: string) =>
    api.post('/auth/login', { email, name, avatar }),
  getUser: (userId: string) => api.get(`/users/${userId}`),
};

export const marketAPI = {
  getCryptoPrices: () => api.get('/market/crypto'),
  getNews: () => api.get('/market/news'),
};

export const tradingAPI = {
  executeTrade: (tradeData: any) => api.post('/trading/execute', tradeData),
  getPortfolio: (userId: string) => api.get(`/portfolio/${userId}`),
  getTransactions: (userId: string) => api.get(`/transactions/${userId}`),
};

export const learningAPI = {
  getLessons: () => api.get('/lessons'),
  getLesson: (lessonId: string) => api.get(`/lessons/${lessonId}`),
  completeLesson: (lessonId: string, userId: string) =>
    api.post(`/lessons/${lessonId}/complete?user_id=${userId}`),
  getQuizzes: (lessonId: string) => api.get(`/quizzes/${lessonId}`),
  submitQuiz: (quizData: any) => api.post('/quizzes/submit', quizData),
};

export const challengesAPI = {
  getDailyChallenges: () => api.get('/challenges/daily'),
};

export const leaderboardAPI = {
  getLeaderboard: () => api.get('/leaderboard'),
};

export const aiAPI = {
  askAssistant: (userId: string, message: string, context?: string) =>
    api.post('/ai/assistant', { user_id: userId, message, context }),
};

export const progressAPI = {
  getProgress: (userId: string) => api.get(`/progress/${userId}`),
};

export default api;
