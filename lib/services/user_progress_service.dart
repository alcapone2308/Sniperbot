import 'package:shared_preferences/shared_preferences.dart';

class UserProgressService {
  static Future<void> saveTimeSpent(int seconds) async {
    final prefs = await SharedPreferences.getInstance();
    final total = prefs.getInt('time_spent') ?? 0;
    await prefs.setInt('time_spent', total + seconds);
  }

  static Future<void> markModuleCompleted(String moduleId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('module_$moduleId', true);
  }

  static Future<bool> isModuleCompleted(String moduleId) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('module_$moduleId') ?? false;
  }

  static Future<int> getTimeSpent() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt('time_spent') ?? 0;
  }

  static Future<int> getProgressPercentage(int totalModules) async {
    final prefs = await SharedPreferences.getInstance();
    int completed = 0;
    for (int i = 0; i < totalModules; i++) {
      if (prefs.getBool('module_module_$i') ?? false) completed++;
    }
    return ((completed / totalModules) * 100).round();
  }
}
