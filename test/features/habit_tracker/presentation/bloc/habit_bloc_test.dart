import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:Aizen/features/habit_tracker/domain/entities/habit.dart';
import 'package:Aizen/features/habit_tracker/domain/entities/relapse_log.dart';
import 'package:Aizen/features/habit_tracker/domain/usecases/get_habits.dart';
import 'package:Aizen/features/habit_tracker/domain/usecases/save_habit.dart';
import 'package:Aizen/features/habit_tracker/domain/usecases/delete_habit.dart';
import 'package:Aizen/features/habit_tracker/domain/usecases/mark_habit_complete.dart';
import 'package:Aizen/features/habit_tracker/domain/usecases/reset_habit_streak.dart';
import 'package:Aizen/features/habit_tracker/presentation/bloc/habit_bloc.dart';
import 'package:Aizen/features/habit_tracker/presentation/bloc/habit_event.dart';
import 'package:Aizen/features/habit_tracker/presentation/bloc/habit_state.dart';

class MockGetHabits extends Mock implements GetHabits {}
class MockSaveHabit extends Mock implements SaveHabit {}
class MockDeleteHabit extends Mock implements DeleteHabit {}
class MockMarkHabitComplete extends Mock implements MarkHabitComplete {}
class MockResetHabitStreak extends Mock implements ResetHabitStreak {}

void main() {
  late MockGetHabits mockGetHabits;
  late MockSaveHabit mockSaveHabit;
  late MockDeleteHabit mockDeleteHabit;
  late MockMarkHabitComplete mockMarkHabitComplete;
  late MockResetHabitStreak mockResetHabitStreak;
  late HabitBloc bloc;

  final tHabit = Habit(
    id: '1',
    title: 'No Sugar',
    createdAt: DateTime.now(),
    currentStreak: 5,
    longestStreak: 10,
    completionHistory: const [],
    relapseLogs: const [],
    pastAttempts: const [],
    isAutomatic: true,
  );

  setUpAll(() {
    registerFallbackValue(tHabit);
  });

  setUp(() {
    mockGetHabits = MockGetHabits();
    mockSaveHabit = MockSaveHabit();
    mockDeleteHabit = MockDeleteHabit();
    mockMarkHabitComplete = MockMarkHabitComplete();
    mockResetHabitStreak = MockResetHabitStreak();

    bloc = HabitBloc(
      getHabits: mockGetHabits,
      saveHabit: mockSaveHabit,
      deleteHabit: mockDeleteHabit,
      markHabitComplete: mockMarkHabitComplete,
      resetHabitStreak: mockResetHabitStreak,
    );
  });

  tearDown(() {
    bloc.close();
  });

  group('HabitBloc Tests', () {
    test('initial state should be empty and initial status', () {
      expect(bloc.state.status, HabitStatus.initial);
      expect(bloc.state.habits, isEmpty);
      expect(bloc.state.errorMessage, isNull);
    });

    blocTest<HabitBloc, HabitState>(
      'should emit [loading, success] when fetching habits is successful',
      build: () {
        when(() => mockGetHabits()).thenAnswer((_) async => (null, [tHabit]));
        return bloc;
      },
      act: (bloc) => bloc.add(const LoadHabitsEvent()),
      expect: () => [
        const HabitState(status: HabitStatus.loading),
        HabitState(status: HabitStatus.success, habits: [tHabit]),
      ],
    );

    blocTest<HabitBloc, HabitState>(
      'should emit [loading, failure] when fetching habits fails',
      build: () {
        when(() => mockGetHabits()).thenAnswer((_) async => (Exception('Error'), null));
        return bloc;
      },
      act: (bloc) => bloc.add(const LoadHabitsEvent()),
      expect: () => [
        const HabitState(status: HabitStatus.loading),
        const HabitState(status: HabitStatus.failure, errorMessage: 'Exception: Error'),
      ],
    );
  });
}
