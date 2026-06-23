import 'package:equatable/equatable.dart';
import 'relapse_log.dart';
import 'streak_attempt.dart';

class Habit extends Equatable {
  final String id;
  final String title;
  final DateTime createdAt;
  final int currentStreak;
  final int longestStreak;
  final DateTime? lastResetAt;
  final DateTime? lastCompletedAt;
  final List<DateTime> completionHistory;
  final List<RelapseLog> relapseLogs;
  final List<StreakAttempt> pastAttempts;
  final bool isAutomatic;

  const Habit({
    required this.id,
    required this.title,
    required this.createdAt,
    required this.currentStreak,
    required this.longestStreak,
    this.lastResetAt,
    this.lastCompletedAt,
    required this.completionHistory,
    required this.relapseLogs,
    required this.pastAttempts,
    this.isAutomatic = true,
  });

  Habit copyWith({
    String? title,
    int? currentStreak,
    int? longestStreak,
    DateTime? lastResetAt,
    DateTime? lastCompletedAt,
    List<DateTime>? completionHistory,
    List<RelapseLog>? relapseLogs,
    List<StreakAttempt>? pastAttempts,
    bool? isAutomatic,
  }) {
    return Habit(
      id: id,
      title: title ?? this.title,
      createdAt: createdAt,
      currentStreak: currentStreak ?? this.currentStreak,
      longestStreak: longestStreak ?? this.longestStreak,
      lastResetAt: lastResetAt ?? this.lastResetAt,
      lastCompletedAt: lastCompletedAt ?? this.lastCompletedAt,
      completionHistory: completionHistory ?? this.completionHistory,
      relapseLogs: relapseLogs ?? this.relapseLogs,
      pastAttempts: pastAttempts ?? this.pastAttempts,
      isAutomatic: isAutomatic ?? this.isAutomatic,
    );
  }

  // Helper getters for Level & Rank
  int get activeStreakDays {
    if (isAutomatic) {
      final start = lastResetAt ?? createdAt;
      return DateTime.now().difference(start).inDays;
    }
    return currentStreak;
  }

  String get levelTitle {
    final days = activeStreakDays;
    if (days < 1) return 'Recruit (Lvl 1)';
    if (days < 3) return 'Apprentice (Lvl 2)';
    if (days < 7) return 'Sentinel (Lvl 3)';
    if (days < 14) return 'Guardian (Lvl 4)';
    if (days < 30) return 'Overlord (Lvl 5)';
    if (days < 60) return 'Conqueror (Lvl 6)';
    if (days < 90) return 'Immortal (Lvl 7)';
    return 'Iron Will (Lvl 8)';
  }

  double get levelProgress {
    final days = activeStreakDays;
    if (days < 1) return days / 1.0;
    if (days < 3) return (days - 1) / 2.0;
    if (days < 7) return (days - 3) / 4.0;
    if (days < 14) return (days - 7) / 7.0;
    if (days < 30) return (days - 14) / 16.0;
    if (days < 60) return (days - 30) / 30.0;
    if (days < 90) return (days - 60) / 30.0;
    return 1.0;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'createdAt': createdAt.toIso8601String(),
      'currentStreak': currentStreak,
      'longestStreak': longestStreak,
      'lastResetAt': lastResetAt?.toIso8601String(),
      'lastCompletedAt': lastCompletedAt?.toIso8601String(),
      'completionHistory': completionHistory.map((d) => d.toIso8601String()).toList(),
      'relapseLogs': relapseLogs.map((r) => r.toJson()).toList(),
      'pastAttempts': pastAttempts.map((a) => a.toJson()).toList(),
      'isAutomatic': isAutomatic,
    };
  }

  factory Habit.fromJson(Map<String, dynamic> json) {
    return Habit(
      id: json['id'] as String,
      title: json['title'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      currentStreak: json['currentStreak'] as int,
      longestStreak: json['longestStreak'] as int,
      lastResetAt: json['lastResetAt'] != null ? DateTime.parse(json['lastResetAt'] as String) : null,
      lastCompletedAt: json['lastCompletedAt'] != null ? DateTime.parse(json['lastCompletedAt'] as String) : null,
      completionHistory: (json['completionHistory'] as List?)
              ?.map((d) => DateTime.parse(d as String))
              .toList() ??
          [],
      relapseLogs: (json['relapseLogs'] as List?)
              ?.map((r) => RelapseLog.fromJson(r as Map<String, dynamic>))
              .toList() ??
          [],
      pastAttempts: (json['pastAttempts'] as List?)
              ?.map((a) => StreakAttempt.fromJson(a as Map<String, dynamic>))
              .toList() ??
          [],
      isAutomatic: json['isAutomatic'] as bool? ?? true,
    );
  }

  @override
  List<Object?> get props => [
        id,
        title,
        createdAt,
        currentStreak,
        longestStreak,
        lastResetAt,
        lastCompletedAt,
        completionHistory,
        relapseLogs,
        pastAttempts,
        isAutomatic,
      ];
}
