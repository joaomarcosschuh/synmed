class DailyStatsModel {
  int xpDia;
  int cartoesVistos;
  int streak;

  DailyStatsModel({
    required this.xpDia,
    required this.cartoesVistos,
    required this.streak,
  });

  // Method to convert the map data to the DailyStatsModel
  factory DailyStatsModel.fromMap(Map<String, dynamic> map) {
    return DailyStatsModel(
      xpDia: map['xpDia'] ?? 0, // provide a default value in case of null
      cartoesVistos: map['cartoesVistos'] ?? 0, // provide a default value in case of null
      streak: map['streak'] ?? 0, // provide a default value in case of null
    );
  }

  // Method to convert the DailyStatsModel data to a map
  Map<String, dynamic> toMap() {
    return {
      'xpDia': xpDia,
      'cartoesVistos': cartoesVistos,
      'streak': streak,
    };
  }

  @override
  String toString() {
    return 'DailyStatsModel(xpDia: $xpDia, cartoesVistos: $cartoesVistos, streak: $streak)';
  }
}
