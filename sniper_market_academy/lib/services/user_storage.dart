import 'package:shared_preferences/shared_preferences.dart';

class UserStorage {
  static Future<void> saveUserData({
    required String username,
    required String gender,
    required String level,
    required String birthDate,
    String? profileImage,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await Future.wait([
      prefs.setString('username', username),
      prefs.setString('gender', gender),
      prefs.setString('level', level),
      prefs.setString('birthDate', birthDate),
      if (profileImage != null) prefs.setString('profileImage', profileImage),
    ]);
  }

  static Future<Map<String, dynamic>> loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    return {
      'username': prefs.getString('username') ?? '',
      'gender': prefs.getString('gender') ?? 'homme',
      'level': prefs.getString('level') ?? 'Débutant',
      'birthDate': prefs.getString('birthDate') ?? '',
      'profileImage': prefs.getString('profileImage'),
    };
  }
}