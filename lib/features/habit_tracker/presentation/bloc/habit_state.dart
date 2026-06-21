import 'package:equatable/equatable.dart';
import '../../domain/entities/habit.dart';

enum HabitStatus { initial, loading, success, failure }

class HabitState extends Equatable {
  final HabitStatus status;
  final List<Habit> habits;
  final String? errorMessage;

  const HabitState({
    this.status = HabitStatus.initial,
    this.habits = const [],
    this.errorMessage,
  });

  HabitState copyWith({
    HabitStatus? status,
    List<Habit>? habits,
    String? errorMessage,
  }) {
    return HabitState(
      status: status ?? this.status,
      habits: habits ?? this.habits,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, habits, errorMessage];
}
