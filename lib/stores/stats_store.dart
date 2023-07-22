import 'package:meu_flash/models/dailystats_model.dart';
import 'package:meu_flash/models/streak_model.dart';
import 'package:meu_flash/services/stats/dailystats_service.dart';
import 'package:meu_flash/services/stats/streak_service.dart';
import 'package:mobx/mobx.dart';

part 'stats_store.g.dart';

class StatsStore = _StatsStore with _$StatsStore;

abstract class _StatsStore with Store {
  final DailyStatsService _dailyStatsService;
  late final StreakService _streakService;

  _StatsStore() : _dailyStatsService = DailyStatsService() {
    _streakService = StreakService(_dailyStatsService);
  }

  @observable
  DailyStatsModel? dailyStats;

  @observable
  StreakModel? streak;

  @action
  Future<void> loadStats(String userId, String statsId) async {
    print('loadStats called with $userId and $statsId');
    dailyStats = await _dailyStatsService.getDailyStats(userId, statsId);
    streak = await _streakService.getStreak(userId);
    print('Stats loaded: $dailyStats $streak');
    print('Document values: DailyStats: ${dailyStats.toString()}, Streak: ${streak.toString()}');
  }

  @action
  Future<void> checkAndUpdateStreak(String userId) async {
    print('checkAndUpdateStreak called with $userId');
    await _streakService.checkAndUpdateStreak(userId);
    streak = await _streakService.getStreak(userId);
    print('Streak updated: $streak');
    print('Document values: Streak: ${streak.toString()}');
  }

  @action
  void updateDailyStatsForStudySession() {
    print('Updating daily stats for study session');
    if (dailyStats != null) {
      dailyStats!.xpDia += 5;
      dailyStats!.cartoesVistos += 1;
    } else {
      dailyStats = DailyStatsModel(xpDia: 5, cartoesVistos: 1, streak: 0);
    }

    // Print the updated daily stats
    print('Updated DailyStats: ${dailyStats.toString()}');
  }

  @action
  Future<void> saveStats(String userId, String statsId) async {
    print('saveStats called with $userId and $statsId');
    if (dailyStats != null) {
      await _dailyStatsService.saveDailyStats(userId, statsId, dailyStats!);
    }
    // After saving the DailyStats, we also reload the Streak to reflect the changes
    streak = await _streakService.getStreak(userId);
  }
}
