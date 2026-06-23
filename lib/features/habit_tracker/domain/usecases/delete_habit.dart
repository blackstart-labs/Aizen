import '../repositories/habit_repository.dart';

class DeleteHabit {
  final HabitRepository repository;

  DeleteHabit(this.repository);

  Future<(Exception?, void)> call(String id) {
    return repository.deleteHabit(id);
  }
}
