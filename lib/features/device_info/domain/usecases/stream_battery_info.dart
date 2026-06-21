import '../entities/battery_info.dart';
import '../repositories/device_info_repository.dart';

class StreamBatteryInfo {
  final DeviceInfoRepository repository;

  const StreamBatteryInfo(this.repository);

  Stream<BatteryInfo> call() => repository.streamBatteryInfo();
}
