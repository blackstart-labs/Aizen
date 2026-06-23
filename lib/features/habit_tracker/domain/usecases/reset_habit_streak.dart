import '../entities/habit.dart';
import '../entities/relapse_log.dart';
import '../repositories/habit_repository.dart';

class ResetHabitStreak {
  final HabitRepository repository;

  ResetHabitStreak(this.repository);

  Future<(Exception?, Habit?)> call(String id, RelapseLog log) {
    return repository.resetStreak(id, log);
  }
}
