import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// ✅ Inscription automatique du joueur dans le classement
Future<void> registerUserInLeaderboard() async {
  final prefs = await SharedPreferences.getInstance();
  final username = prefs.getString('username') ?? 'Nouveau Trader';

  if (username.isEmpty) return;

  final leaderboardRef =
  FirebaseFirestore.instance.collection('leaderboard').doc(username);

  final doc = await leaderboardRef.get();

  if (!doc.exists) {
    // 🔥 Si le joueur n’existe pas encore → on l’ajoute avec 0 points
    await leaderboardRef.set({
      'username': username,
      'score': 0,
      'createdAt': FieldValue.serverTimestamp(),
    });
  } else {
    // 🔄 Si le joueur existe → on s’assure que le pseudo est bien mis à jour
    await leaderboardRef.set(
      {
        'username': username,
      },
      SetOptions(merge: true),
    );
  }
}
