import 'package:equatable/equatable.dart';

class RelapseLog extends Equatable {
  final String id;
  final String habitId;
  final DateTime timestamp;
  final String rootCause;
  final String trigger;
  final int severity;
  final String notes;

  const RelapseLog({
    required this.id,
    required this.habitId,
    required this.timestamp,
    required this.rootCause,
    required this.trigger,
    required this.severity,
    required this.notes,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'habitId': habitId,
      'timestamp': timestamp.toIso8601String(),
      'rootCause': rootCause,
      'trigger': trigger,
      'severity': severity,
      'notes': notes,
    };
  }

  factory RelapseLog.fromJson(Map<String, dynamic> json) {
    return RelapseLog(
      id: json['id'] as String,
      habitId: json['habitId'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
      rootCause: json['rootCause'] as String,
      trigger: json['trigger'] as String,
      severity: json['severity'] as int,
      notes: json['notes'] as String,
    );
  }

  @override
  List<Object?> get props => [id, habitId, timestamp, rootCause, trigger, severity, notes];
}
