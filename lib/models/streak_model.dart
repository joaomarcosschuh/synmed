class StreakModel {
  Map<String, bool> dailyLogins;
  int streak;
  int totalXP;

  StreakModel({
    required this.dailyLogins,
    required this.streak,
    required this.totalXP,
  });

  factory StreakModel.fromMap(Map<String, dynamic> map) {
    Map<String, bool> dailyLogins = Map<String, bool>.from(map['dailyLogins']);
    return StreakModel(
      dailyLogins: dailyLogins,
      streak: map['streak'] ?? 0, // handle null
      totalXP: map['totalXP'] ?? 0, // handle null
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'dailyLogins': dailyLogins,
      'streak': streak,
      'totalXP': totalXP,
    };
  }

  @override
  String toString() {
    return 'StreakModel(dailyLogins: $dailyLogins, streak: $streak, totalXP: $totalXP)';
  }
}
