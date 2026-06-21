import 'package:equatable/equatable.dart';

enum ChargingStatus {
  charging,
  discharging,
  full,
  unknown
}

class BatteryInfo extends Equatable {
  final int percentage;
  final ChargingStatus status;
  final String health;
  final double? temperature; // In Celsius

  const BatteryInfo({
    required this.percentage,
    required this.status,
    required this.health,
    this.temperature,
  });

  @override
  List<Object?> get props => [percentage, status, health, temperature];
}
