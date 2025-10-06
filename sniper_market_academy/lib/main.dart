import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:hive_flutter/hive_flutter.dart';

// Services
import 'services/hive_service.dart';
import 'services/progress_service.dart';

// Providers
import 'providers/theme_provider.dart';
import 'providers/user_provider.dart';

// Screens
import 'screens/splash_screen.dart';
import 'screens/home/home_page.dart';
import 'screens/modules/modules_page.dart';
import 'screens/exercises/exercises_page.dart';
import 'screens/progression/progression_page.dart';
import 'screens/glossary/glossary_page.dart';
import 'screens/settings/settings_page.dart';
import 'screens/simulator/simulator_page.dart';

// Theme
import 'theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialiser Hive
  await Hive.initFlutter();
  
  // Initialiser les services
  await HiveService.init();
  await ProgressService.init();
  
  runApp(const SniperMarketAcademy());
}

class SniperMarketAcademy extends StatelessWidget {
  const SniperMarketAcademy({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => UserProvider()),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, _) {
          return MaterialApp(
            title: 'Sniper Market Academy',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: themeProvider.themeMode,
            initialRoute: '/',
            routes: {
              '/': (context) => const SplashScreen(),
              '/home': (context) => const HomePage(),
              '/modules': (context) => const ModulesPage(),
              '/exercises': (context) => const ExercisesPage(),
              '/progression': (context) => const ProgressionPage(),
              '/glossary': (context) => const GlossaryPage(),
              '/settings': (context) => const SettingsPage(),
              '/simulator': (context) => const SimulatorPage(),
            },
          );
        },
      ),
    );
  }
}
