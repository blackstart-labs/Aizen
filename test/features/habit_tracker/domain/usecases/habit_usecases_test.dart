import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:Aizen/features/habit_tracker/domain/entities/habit.dart';
import 'package:Aizen/features/habit_tracker/domain/entities/relapse_log.dart';
import 'package:Aizen/features/habit_tracker/domain/repositories/habit_repository.dart';
import 'package:Aizen/features/habit_tracker/domain/usecases/get_habits.dart';
import 'package:Aizen/features/habit_tracker/domain/usecases/save_habit.dart';
import 'package:Aizen/features/habit_tracker/domain/usecases/delete_habit.dart';
import 'package:Aizen/features/habit_tracker/domain/usecases/mark_habit_complete.dart';
import 'package:Aizen/features/habit_tracker/domain/usecases/reset_habit_streak.dart';

class MockHabitRepository extends Mock implements HabitRepository {}

void main() {
  late MockHabitRepository mockRepository;
  late GetHabits getHabits;
  late SaveHabit saveHabit;
  late DeleteHabit deleteHabit;
  late MarkHabitComplete markHabitComplete;
  late ResetHabitStreak resetHabitStreak;

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

  setUp(() {
    mockRepository = MockHabitRepository();
    getHabits = GetHabits(mockRepository);
    saveHabit = SaveHabit(mockRepository);
    deleteHabit = DeleteHabit(mockRepository);
    markHabitComplete = MarkHabitComplete(mockRepository);
    resetHabitStreak = ResetHabitStreak(mockRepository);
  });

  group('Habit Tracker Usecases Tests', () {
    test('should get habits from repository', () async {
      when(() => mockRepository.getHabits()).thenAnswer((_) async => (null, [tHabit]));

      final result = await getHabits();

      expect(result.$1, isNull);
      expect(result.$2, [tHabit]);
      verify(() => mockRepository.getHabits()).called(1);
    });

    test('should save habit in repository', () async {
      when(() => mockRepository.saveHabit(tHabit)).thenAnswer((_) async => (null, null));

      final result = await saveHabit(tHabit);

      expect(result.$1, isNull);
      verify(() => mockRepository.saveHabit(tHabit)).called(1);
    });

    test('should delete habit in repository', () async {
      when(() => mockRepository.deleteHabit('1')).thenAnswer((_) async => (null, null));

      final result = await deleteHabit('1');

      expect(result.$1, isNull);
      verify(() => mockRepository.deleteHabit('1')).called(1);
    });

    test('should mark habit complete in repository', () async {
      final date = DateTime.now();
      when(() => mockRepository.markComplete('1', date)).thenAnswer((_) async => (null, tHabit));

      final result = await markHabitComplete('1', date);

      expect(result.$1, isNull);
      expect(result.$2, tHabit);
      verify(() => mockRepository.markComplete('1', date)).called(1);
    });

    test('should reset habit streak in repository', () async {
      final log = RelapseLog(
        id: 'log1',
        habitId: '1',
        timestamp: DateTime.now(),
        rootCause: 'Stress',
        trigger: 'Exam',
        severity: 4,
        notes: 'tough time',
      );
      when(() => mockRepository.resetStreak('1', log)).thenAnswer((_) async => (null, tHabit));

      final result = await resetHabitStreak('1', log);

      expect(result.$1, isNull);
      expect(result.$2, tHabit);
      verify(() => mockRepository.resetStreak('1', log)).called(1);
    });
  });
}
