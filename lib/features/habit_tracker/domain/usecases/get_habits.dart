import '../entities/habit.dart';
import '../repositories/habit_repository.dart';

class GetHabits {
  final HabitRepository repository;

  GetHabits(this.repository);

  Future<(Exception?, List<Habit>?)> call() {
    return repository.getHabits();
  }
}
