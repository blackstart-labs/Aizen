import '../../domain/entities/battery_info.dart';

class BatteryInfoModel extends BatteryInfo {
  const BatteryInfoModel({
    required super.percentage,
    required super.status,
    required super.health,
    super.temperature,
  });

  factory BatteryInfoModel.fromJson(Map<String, dynamic> json) {
    return BatteryInfoModel(
      percentage: json['percentage'] ?? 0,
      status: ChargingStatus.values.firstWhere(
        (e) => e.toString() == json['status'],
        orElse: () => ChargingStatus.unknown,
      ),
      health: json['health'] ?? 'Good',
      temperature: json['temperature'] != null ? (json['temperature'] as num).toDouble() : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'percentage': percentage,
      'status': status.toString(),
      'health': health,
      'temperature': temperature,
    };
  }
}
