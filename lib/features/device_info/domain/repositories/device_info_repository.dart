import '../../../../core/error/failures.dart';
import '../entities/battery_info.dart';
import '../entities/hardware_info.dart';
import '../entities/storage_info.dart';

abstract class DeviceInfoRepository {
  Future<(Failure?, HardwareInfo?)> getHardwareInfo();
  Future<(Failure?, StorageInfo?)> getStorageInfo();
  Stream<BatteryInfo> streamBatteryInfo();
}
