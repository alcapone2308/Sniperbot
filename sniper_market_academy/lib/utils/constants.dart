class AppConstants {
  // App info
  static const String appName = 'Sniper Market Academy';
  static const String appVersion = '2.0.0';
  
  // Storage keys
  static const String userBoxName = 'user_box';
  static const String progressBoxName = 'progress_box';
  static const String tradesBoxName = 'trades_box';
  static const String settingsBoxName = 'settings_box';
  
  // SharedPreferences keys
  static const String themeKey = 'theme_mode';
  static const String notificationsKey = 'notifications_enabled';
  static const String soundKey = 'sound_enabled';
  
  // XP values
  static const int xpPerModule = 100;
  static const int xpPerExercise = 50;
  static const int xpPerQuiz = 25;
  static const int xpForLevelUp = 500;
  
  // Modules
  static const List<String> moduleIds = [
    'market_structure',
    'bos',
    'fvg',
    'ote',
    'liquidity',
    'displacement',
    'orderblock',
    'kill_zones',
    'silver_bullet',
  ];
  
  static const Map<String, String> moduleNames = {
    'market_structure': 'Structure du Marché',
    'bos': 'Break of Structure',
    'fvg': 'Fair Value Gap',
    'ote': 'Optimal Trade Entry',
    'liquidity': 'Liquidité',
    'displacement': 'Displacement',
    'orderblock': 'Order Block',
    'kill_zones': 'Kill Zones',
    'silver_bullet': 'Silver Bullet',
  };
}
