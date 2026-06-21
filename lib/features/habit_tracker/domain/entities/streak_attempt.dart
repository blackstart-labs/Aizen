import 'package:equatable/equatable.dart';

class StreakAttempt extends Equatable {
  final String id;
  final String habitId;
  final DateTime startDate;
  final DateTime endDate;
  final int durationDays;
  final String rootCause;
  final String trigger;

  const StreakAttempt({
    required this.id,
    required this.habitId,
    required this.startDate,
    required this.endDate,
    required this.durationDays,
    required this.rootCause,
    required this.trigger,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'habitId': habitId,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
      'durationDays': durationDays,
      'rootCause': rootCause,
      'trigger': trigger,
    };
  }

  factory StreakAttempt.fromJson(Map<String, dynamic> json) {
    return StreakAttempt(
      id: json['id'] as String,
      habitId: json['habitId'] as String,
      startDate: DateTime.parse(json['startDate'] as String),
      endDate: DateTime.parse(json['endDate'] as String),
      durationDays: json['durationDays'] as int,
      rootCause: json['rootCause'] as String,
      trigger: json['trigger'] as String,
    );
  }

  @override
  List<Object?> get props => [id, habitId, startDate, endDate, durationDays, rootCause, trigger];
}
