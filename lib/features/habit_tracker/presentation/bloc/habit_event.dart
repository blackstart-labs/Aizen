import 'package:equatable/equatable.dart';
import '../../domain/entities/relapse_log.dart';

abstract class HabitEvent extends Equatable {
  const HabitEvent();

  @override
  List<Object?> get props => [];
}

class LoadHabitsEvent extends HabitEvent {
  const LoadHabitsEvent();
}

class AddHabitEvent extends HabitEvent {
  final String title;
  final bool isAutomatic;

  const AddHabitEvent({required this.title, required this.isAutomatic});

  @override
  List<Object?> get props => [title, isAutomatic];
}

class CompleteHabitDayEvent extends HabitEvent {
  final String id;
  final DateTime date;

  const CompleteHabitDayEvent({required this.id, required this.date});

  @override
  List<Object?> get props => [id, date];
}

class ResetHabitEvent extends HabitEvent {
  final String id;
  final RelapseLog log;

  const ResetHabitEvent({required this.id, required this.log});

  @override
  List<Object?> get props => [id, log];
}

class DeleteHabitEvent extends HabitEvent {
  final String id;

  const DeleteHabitEvent(this.id);

  @override
  List<Object?> get props => [id];
}
