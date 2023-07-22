import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meu_flash/models/dailystats_model.dart';

class DailyStatsService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> saveDailyStats(String userId, String statsId, DailyStatsModel dailyStats) async {
    DocumentReference docRef = _firestore.collection('users')
        .doc(userId)
        .collection('statistics')
        .doc(statsId);

    DocumentReference streakDocRef = _firestore.collection('users')
        .doc(userId)
        .collection('streak')
        .doc('streak');

    await docRef.set(dailyStats.toMap());

    // Fetch current streak document
    DocumentSnapshot currentStreak = await streakDocRef.get();

    // If the document exists, update totalXP
    if (currentStreak.exists) {
      Map<String, dynamic> data = currentStreak.data() as Map<String, dynamic>;
      data['totalXP'] = (data['totalXP'] ?? 0) + dailyStats.xpDia;

      await streakDocRef.set(data);
    }
  }

  Future<DailyStatsModel?> getDailyStats(String userId, String statsId) async {
    DocumentSnapshot docSnapshot = await _firestore.collection('users').doc(userId).collection('statistics').doc(statsId).get();

    if (docSnapshot.exists) {
      Map<String, dynamic> data = docSnapshot.data() as Map<String, dynamic>;
      return DailyStatsModel.fromMap(data);
    }

    return null;
  }

  Future<void> createDailyStats(String userId, String statsId, DailyStatsModel dailyStats) async {
    DocumentReference docRef = _firestore.collection('users')
        .doc(userId)
        .collection('statistics')
        .doc(statsId);

    DocumentSnapshot currentDoc = await docRef.get();

    if (!currentDoc.exists) {
      await docRef.set(dailyStats.toMap());
    }
  }
}
