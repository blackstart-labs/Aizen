import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../domain/entities/habit.dart';

abstract class HabitLocalDataSource {
  Future<List<Habit>> getHabits();
  Future<void> saveHabits(List<Habit> habits);
}

class HabitLocalDataSourceImpl implements HabitLocalDataSource {
  final SharedPreferences sharedPreferences;
  static const String _key = 'habits_list';

  HabitLocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future<List<Habit>> getHabits() async {
    final jsonStr = sharedPreferences.getString(_key);
    if (jsonStr == null) return [];
    try {
      final List<dynamic> decoded = json.decode(jsonStr);
      return decoded.map((item) => Habit.fromJson(item as Map<String, dynamic>)).toList();
    } catch (e) {
      return [];
    }
  }

  @override
  Future<void> saveHabits(List<Habit> habits) async {
    final list = habits.map((h) => h.toJson()).toList();
    final jsonStr = json.encode(list);
    await sharedPreferences.setString(_key, jsonStr);
  }
}
