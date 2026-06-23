import 'package:flutter/foundation.dart';
import '../../domain/entities/habit.dart';
import '../../domain/entities/relapse_log.dart';
import '../../domain/entities/streak_attempt.dart';
import '../../domain/repositories/habit_repository.dart';
import '../datasources/habit_local_data_source.dart';

class HabitRepositoryImpl implements HabitRepository {
  final HabitLocalDataSource localDataSource;

  HabitRepositoryImpl({required this.localDataSource});

  @override
  Future<(Exception?, List<Habit>?)> getHabits() async {
    try {
      final habits = await localDataSource.getHabits();
      return (null, habits);
    } catch (e) {
      return (Exception(e.toString()), null);
    }
  }

  @override
  Future<(Exception?, void)> saveHabit(Habit habit) async {
    try {
      final habits = await localDataSource.getHabits();
      final index = habits.indexWhere((h) => h.id == habit.id);
      if (index != -1) {
        habits[index] = habit;
      } else {
        habits.add(habit);
      }
      await localDataSource.saveHabits(habits);
      return (null, null);
    } catch (e) {
      return (Exception(e.toString()), null);
    }
  }

  @override
  Future<(Exception?, void)> deleteHabit(String id) async {
    try {
      final habits = await localDataSource.getHabits();
      habits.removeWhere((h) => h.id == id);
      await localDataSource.saveHabits(habits);
      return (null, null);
    } catch (e) {
      return (Exception(e.toString()), null);
    }
  }

  @override
  Future<(Exception?, Habit?)> markComplete(String id, DateTime date) async {
    try {
      final habits = await localDataSource.getHabits();
      final index = habits.indexWhere((h) => h.id == id);
      if (index == -1) {
        return (Exception('Habit not found'), null);
      }

      final habit = habits[index];
      final dayToMark = DateTime(date.year, date.month, date.day);

      // Check if already completed on this exact day
      final alreadyCompleted = habit.completionHistory.any(
        (d) => d.year == dayToMark.year && d.month == dayToMark.month && d.day == dayToMark.day,
      );

      if (alreadyCompleted) {
        return (null, habit);
      }

      final updatedHistory = List<DateTime>.from(habit.completionHistory)..add(dayToMark);
      // Sort completions in ascending order for calculations
      updatedHistory.sort((a, b) => a.compareTo(b));

      // Calculate current streak
      int calculatedStreak = 0;
      if (updatedHistory.isNotEmpty) {
        // Normalize today
        final now = DateTime.now();
        final today = DateTime(now.year, now.month, now.day);
        final yesterday = today.subtract(const Duration(days: 1));

        final lastCompletion = updatedHistory.last;
        // Streak is active if last completed is either today or yesterday
        if (lastCompletion.isAtSameMomentAs(today) || lastCompletion.isAtSameMomentAs(yesterday)) {
          calculatedStreak = 1;
          for (int i = updatedHistory.length - 1; i > 0; i--) {
            final diff = updatedHistory[i].difference(updatedHistory[i - 1]).inDays;
            if (diff == 1) {
              calculatedStreak++;
            } else if (diff > 1) {
              // Streak broken
              break;
            }
          }
        }
      }

      final newLongest = calculatedStreak > habit.longestStreak ? calculatedStreak : habit.longestStreak;

      final updatedHabit = habit.copyWith(
        currentStreak: calculatedStreak,
        longestStreak: newLongest,
        lastCompletedAt: dayToMark,
        completionHistory: updatedHistory,
      );

      habits[index] = updatedHabit;
      await localDataSource.saveHabits(habits);
      return (null, updatedHabit);
    } catch (e) {
      return (Exception(e.toString()), null);
    }
  }

  @override
  Future<(Exception?, Habit?)> resetStreak(String id, RelapseLog log) async {
    try {
      final habits = await localDataSource.getHabits();
      final index = habits.indexWhere((h) => h.id == id);
      if (index == -1) {
        return (Exception('Habit not found'), null);
      }

      final habit = habits[index];
      
      // Save current streak as a past attempt if duration > 0
      final List<StreakAttempt> updatedAttempts = List<StreakAttempt>.from(habit.pastAttempts);
      final List<RelapseLog> updatedLogs = List<RelapseLog>.from(habit.relapseLogs)..add(log);

      final startDate = habit.lastResetAt ?? habit.createdAt;
      final attempt = StreakAttempt(
        id: UniqueKey().toString(),
        habitId: habit.id,
        startDate: startDate,
        endDate: log.timestamp,
        durationDays: habit.currentStreak,
        rootCause: log.rootCause,
        trigger: log.trigger,
      );
      updatedAttempts.add(attempt);

      final updatedHabit = habit.copyWith(
        currentStreak: 0,
        lastResetAt: log.timestamp,
        relapseLogs: updatedLogs,
        pastAttempts: updatedAttempts,
      );

      habits[index] = updatedHabit;
      await localDataSource.saveHabits(habits);
      return (null, updatedHabit);
    } catch (e) {
      return (Exception(e.toString()), null);
    }
  }
}
