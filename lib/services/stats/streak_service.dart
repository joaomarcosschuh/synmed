import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meu_flash/models/streak_model.dart';
import 'package:meu_flash/services/stats/dailystats_service.dart';

class StreakService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final DailyStatsService _dailyStatsService;

  StreakService(this._dailyStatsService);

  Future<void> updateStreak(String userId, StreakModel streak) async {
    DocumentReference docRef = _firestore
        .collection('users')
        .doc(userId)
        .collection('statistics')
        .doc('streak');

    await docRef.set(streak.toMap());
  }

  Future<StreakModel> getStreak(String userId) async {
    DocumentSnapshot docSnapshot = await _firestore
        .collection('users')
        .doc(userId)
        .collection('statistics')
        .doc('streak')
        .get();
    if (docSnapshot.exists) {
      Map<String, dynamic>? data = docSnapshot.data() as Map<String, dynamic>?; // Explicit cast
      if (data != null) {
        return StreakModel.fromMap(data);
      }
    }

    throw Exception('Streak data not found');
  }

  Future<void> checkAndUpdateStreak(String userId) async {
    try {
      StreakModel streak = await getStreak(userId);
      DateTime now = DateTime.now();
      String today = '${now.day}-${now.month}-${now.year}';
      String yesterday = '${now.day - 1}-${now.month}-${now.year}';

      if (streak.dailyLogins[yesterday] == true) {
        if (await _dailyStatsService.getDailyStats(userId, today) != null) {
          streak.dailyLogins[today] = true;
          streak.streak += 1;
          streak.totalXP += 10; // Exemplo: Adicionando 10 XP por dia de sequência
        } else {
          streak.streak = 0;
        }
      } else {
        streak.streak = await _dailyStatsService.getDailyStats(userId, today) != null ? 1 : 0;
        streak.dailyLogins[today] = streak.streak == 1;
      }

      await updateStreak(userId, streak);
    } catch (e) {
      print('Error: $e');
    }
  }
}
