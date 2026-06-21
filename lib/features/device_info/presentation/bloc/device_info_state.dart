import 'package:equatable/equatable.dart';
import '../../domain/entities/battery_info.dart';
import '../../domain/entities/hardware_info.dart';
import '../../domain/entities/storage_info.dart';

enum DeviceInfoStatus { initial, loading, success, failure }

class DeviceInfoState extends Equatable {
  final DeviceInfoStatus status;
  final HardwareInfo? hardwareInfo;
  final BatteryInfo? batteryInfo;
  final StorageInfo? storageInfo;
  final String? errorMessage;

  const DeviceInfoState({
    this.status = DeviceInfoStatus.initial,
    this.hardwareInfo,
    this.batteryInfo,
    this.storageInfo,
    this.errorMessage,
  });

  DeviceInfoState copyWith({
    DeviceInfoStatus? status,
    HardwareInfo? hardwareInfo,
    BatteryInfo? batteryInfo,
    StorageInfo? storageInfo,
    String? errorMessage,
  }) {
    return DeviceInfoState(
      status: status ?? this.status,
      hardwareInfo: hardwareInfo ?? this.hardwareInfo,
      batteryInfo: batteryInfo ?? this.batteryInfo,
      storageInfo: storageInfo ?? this.storageInfo,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, hardwareInfo, batteryInfo, storageInfo, errorMessage];
}
