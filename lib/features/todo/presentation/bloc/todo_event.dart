import 'package:equatable/equatable.dart';
import '../../domain/entities/task.dart';

abstract class TodoEvent extends Equatable {
  const TodoEvent();

  @override
  List<Object?> get props => [];
}

class LoadTodosEvent extends TodoEvent {
  const LoadTodosEvent();
}

class AddTodoEvent extends TodoEvent {
  final String nlpInput;
  final DateTime? manualDueDate;

  const AddTodoEvent(this.nlpInput, {this.manualDueDate});

  @override
  List<Object?> get props => [nlpInput, manualDueDate];
}

class ToggleTodoEvent extends TodoEvent {
  final String taskId;

  const ToggleTodoEvent(this.taskId);

  @override
  List<Object?> get props => [taskId];
}

class DeleteTodoEvent extends TodoEvent {
  final String taskId;

  const DeleteTodoEvent(this.taskId);

  @override
  List<Object?> get props => [taskId];
}

class ToggleSubtaskEvent extends TodoEvent {
  final String taskId;
  final String subtaskId;

  const ToggleSubtaskEvent({
    required this.taskId,
    required this.subtaskId,
  });

  @override
  List<Object?> get props => [taskId, subtaskId];
}

enum SortOrder { priority, dueDate, creationDate }

class ChangeSortOrderEvent extends TodoEvent {
  final SortOrder sortOrder;

  const ChangeSortOrderEvent(this.sortOrder);

  @override
  List<Object?> get props => [sortOrder];
}

class RescheduleTodoEvent extends TodoEvent {
  final String taskId;
  final DateTime? dueDate;

  const RescheduleTodoEvent({
    required this.taskId,
    this.dueDate,
  });

  @override
  List<Object?> get props => [taskId, dueDate];
}

class UpdateTodoEvent extends TodoEvent {
  final Task task;

  const UpdateTodoEvent(this.task);

  @override
  List<Object?> get props => [task];
}
