import '../entities/habit.dart';
import '../repositories/habit_repository.dart';

class MarkHabitComplete {
  final HabitRepository repository;

  MarkHabitComplete(this.repository);

  Future<(Exception?, Habit?)> call(String id, DateTime date) {
    return repository.markComplete(id, date);
  }
}
