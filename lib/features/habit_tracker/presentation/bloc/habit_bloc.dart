import 'dart:async';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/foundation.dart';
import '../../domain/entities/habit.dart';
import '../../domain/usecases/get_habits.dart';
import '../../domain/usecases/save_habit.dart';
import '../../domain/usecases/delete_habit.dart';
import '../../domain/usecases/mark_habit_complete.dart';
import '../../domain/usecases/reset_habit_streak.dart';
import 'habit_event.dart';
import 'habit_state.dart';

class HabitBloc extends Bloc<HabitEvent, HabitState> {
  final GetHabits getHabits;
  final SaveHabit saveHabit;
  final DeleteHabit deleteHabit;
  final MarkHabitComplete markHabitComplete;
  final ResetHabitStreak resetHabitStreak;

  static const MethodChannel _channel = MethodChannel('com.aizen.app/hardware_bridge');

  HabitBloc({
    required this.getHabits,
    required this.saveHabit,
    required this.deleteHabit,
    required this.markHabitComplete,
    required this.resetHabitStreak,
  }) : super(const HabitState()) {
    on<LoadHabitsEvent>(_onLoadHabits);
    on<AddHabitEvent>(_onAddHabit);
    on<CompleteHabitDayEvent>(_onCompleteDay);
    on<ResetHabitEvent>(_onResetHabit);
    on<DeleteHabitEvent>(_onDeleteHabit);
  }

  Future<void> _triggerWidgetUpdate() async {
    try {
      await _channel.invokeMethod('updateHabitWidget');
    } catch (e) {
      debugPrint('Failed to update Android widget: $e');
    }
  }

  Future<void> _onLoadHabits(
    LoadHabitsEvent event,
    Emitter<HabitState> emit,
  ) async {
    emit(state.copyWith(status: HabitStatus.loading));
    final res = await getHabits();
    if (res.$1 != null) {
      emit(state.copyWith(status: HabitStatus.failure, errorMessage: res.$1!.toString()));
    } else {
      emit(state.copyWith(status: HabitStatus.success, habits: res.$2 ?? []));
    }
  }

  Future<void> _onAddHabit(
    AddHabitEvent event,
    Emitter<HabitState> emit,
  ) async {
    final habit = Habit(
      id: UniqueKey().toString(),
      title: event.title,
      createdAt: DateTime.now(),
      currentStreak: 0,
      longestStreak: 0,
      completionHistory: const [],
      relapseLogs: const [],
      pastAttempts: const [],
      isAutomatic: event.isAutomatic,
    );

    final res = await saveHabit(habit);
    if (res.$1 != null) {
      emit(state.copyWith(status: HabitStatus.failure, errorMessage: res.$1!.toString()));
    } else {
      add(const LoadHabitsEvent());
      _triggerWidgetUpdate();
    }
  }

  Future<void> _onCompleteDay(
    CompleteHabitDayEvent event,
    Emitter<HabitState> emit,
  ) async {
    final res = await markHabitComplete(event.id, event.date);
    if (res.$1 != null) {
      emit(state.copyWith(status: HabitStatus.failure, errorMessage: res.$1!.toString()));
    } else {
      add(const LoadHabitsEvent());
      _triggerWidgetUpdate();
    }
  }

  Future<void> _onResetHabit(
    ResetHabitEvent event,
    Emitter<HabitState> emit,
  ) async {
    final res = await resetHabitStreak(event.id, event.log);
    if (res.$1 != null) {
      emit(state.copyWith(status: HabitStatus.failure, errorMessage: res.$1!.toString()));
    } else {
      add(const LoadHabitsEvent());
      _triggerWidgetUpdate();
    }
  }

  Future<void> _onDeleteHabit(
    DeleteHabitEvent event,
    Emitter<HabitState> emit,
  ) async {
    final res = await deleteHabit(event.id);
    if (res.$1 != null) {
      emit(state.copyWith(status: HabitStatus.failure, errorMessage: res.$1!.toString()));
    } else {
      add(const LoadHabitsEvent());
      _triggerWidgetUpdate();
    }
  }
}
