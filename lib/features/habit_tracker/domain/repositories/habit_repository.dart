import '../entities/habit.dart';
import '../entities/relapse_log.dart';

abstract class HabitRepository {
  Future<(Exception?, List<Habit>?)> getHabits();
  Future<(Exception?, void)> saveHabit(Habit habit);
  Future<(Exception?, void)> deleteHabit(String id);
  Future<(Exception?, Habit?)> markComplete(String id, DateTime date);
  Future<(Exception?, Habit?)> resetStreak(String id, RelapseLog log);
}
