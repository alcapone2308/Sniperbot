import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';

// ✅ Providers
import 'providers/trade_provider.dart';

// ✅ Exercices
import 'exercises/bos_exercise.dart';
import 'exercises/fvg_exercise.dart';
import 'exercises/liquidity_exercice1.dart';
import 'exercises/orderblock_exercice1.dart';
import 'exercises/ote_exercice1.dart';
import 'exercises/displacement_exercice1.dart';
import 'exercises/scalp_ready_assistant_exercise1.dart';
import 'exercises/setup_complet_exercises.dart';
import 'exercises/ict_quiz_page.dart';

// ✅ Écrans principaux
import 'screens/home_page.dart';
import 'screens/modules_page.dart';
import 'screens/exercises_page.dart';
import 'screens/progression_page.dart';
import 'screens/glossary_page.dart';
import 'screens/edit_profile_page.dart';
import 'screens/trading_bot_page.dart';
import 'screens/economic_announcements_page.dart';
import 'screens/trade_simulator_page.dart';
import 'screens/splash_screen.dart';
import 'screens/prop_firm_info_page.dart';
import 'screens/trade_history_page.dart';
import 'screens/leaderboard_page.dart'; // ✅ Classement global

// ✅ Abonnement & Promo
import 'services/subscription_page.dart';
import 'services/activate_promo_page.dart';

// ✅ Nouveau service pour gérer le classement
import 'services/leaderboard_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(); // ✅ Initialisation Firebase

  final prefs = await SharedPreferences.getInstance();

  // ✅ Expiration automatique de l’abonnement
  final isSubscribed = prefs.getBool('sniperbot_abonnement_actif') ?? false;
  final abonnementDateStr = prefs.getString('abonnement_date');

  if (isSubscribed && abonnementDateStr != null) {
    final abonnementDate = DateTime.tryParse(abonnementDateStr);
    final expiration = abonnementDate?.add(const Duration(days: 30));
    if (expiration != null && DateTime.now().isAfter(expiration)) {
      await prefs.setBool('sniperbot_abonnement_actif', false);
      await prefs.setInt('upload_count', 0);
      await prefs.remove('abonnement_date');
      print("🔒 Abonnement expiré automatiquement désactivé");
    }
  }

  // ✅ Initialisation TradeProvider
  final tradeProvider = TradeProvider();
  await tradeProvider.loadTrade();

  // ✅ Enregistrer automatiquement le joueur dans le classement
  await registerUserInLeaderboard();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => tradeProvider),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sniper Market Academy',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(useMaterial3: true),
      initialRoute: '/',
      routes: {
        // ✅ Page d’accueil
        '/': (context) => const SplashScreen(),
        '/home': (context) => const HomePage(),

        // ✅ Navigation principale
        '/modules': (context) => const ModulesPage(),
        '/exercises': (context) => const ExercisesPage(),
        '/progression': (context) => const ProgressionPage(),
        '/glossary': (context) => const GlossaryPage(),
        '/editProfile': (context) => const EditProfilePage(),
        '/subscription': (context) => const SubscriptionPage(),
        '/sniperbot': (context) => const TradingBotPage(),
        '/promo': (context) => const ActivatePromoPage(),
        '/ict_quiz': (context) => const ICTQuizPage(),
        '/economic_announcements': (context) =>
        const EconomicAnnouncementsPage(),
        '/simulateur': (context) => const TradeSimulatorPage(),
        '/propfirm': (context) => const PropFirmInfoPage(),
        '/trade_history': (context) => const TradeHistoryPage(),
        '/leaderboard': (context) => const LeaderboardPage(),

        // ✅ Exercices interactifs
        '/bos_exercise': (context) => const BOSExercise(),
        '/fvg_exercise': (context) => const FvgExercise(),
        '/liquidity_exercice1': (context) => const LiquidityExercice1(),
        '/orderblock_exercice1': (context) => const OrderblockExercice1(),
        '/ote_exercice1': (context) => const OteExercice1(),
        '/displacement_exercice1': (context) =>
        const DisplacementExercice1(),
        '/scalp_ready_exercise1': (context) =>
        const ScalpReadyAssistantExercise1(),
        '/setup_complet_exercise': (context) =>
        const SetupCompletExercises(),
      },
    );
  }
}
