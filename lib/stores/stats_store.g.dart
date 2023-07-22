// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stats_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$StatsStore on _StatsStore, Store {
  late final _$dailyStatsAtom =
      Atom(name: '_StatsStore.dailyStats', context: context);

  @override
  DailyStatsModel? get dailyStats {
    _$dailyStatsAtom.reportRead();
    return super.dailyStats;
  }

  @override
  set dailyStats(DailyStatsModel? value) {
    _$dailyStatsAtom.reportWrite(value, super.dailyStats, () {
      super.dailyStats = value;
    });
  }

  late final _$streakAtom = Atom(name: '_StatsStore.streak', context: context);

  @override
  StreakModel? get streak {
    _$streakAtom.reportRead();
    return super.streak;
  }

  @override
  set streak(StreakModel? value) {
    _$streakAtom.reportWrite(value, super.streak, () {
      super.streak = value;
    });
  }

  late final _$loadStatsAsyncAction =
      AsyncAction('_StatsStore.loadStats', context: context);

  @override
  Future<void> loadStats(String userId, String statsId) {
    return _$loadStatsAsyncAction.run(() => super.loadStats(userId, statsId));
  }

  late final _$checkAndUpdateStreakAsyncAction =
      AsyncAction('_StatsStore.checkAndUpdateStreak', context: context);

  @override
  Future<void> checkAndUpdateStreak(String userId) {
    return _$checkAndUpdateStreakAsyncAction
        .run(() => super.checkAndUpdateStreak(userId));
  }

  @override
  String toString() {
    return '''
dailyStats: ${dailyStats},
streak: ${streak}
    ''';
  }
}
