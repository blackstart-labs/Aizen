import '../entities/habit.dart';
import '../repositories/habit_repository.dart';

class SaveHabit {
  final HabitRepository repository;

  SaveHabit(this.repository);

  Future<(Exception?, void)> call(Habit habit) {
    return repository.saveHabit(habit);
  }
}
