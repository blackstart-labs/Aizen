import '../../../../core/error/failures.dart';
import '../../domain/entities/battery_info.dart';
import '../../domain/entities/hardware_info.dart';
import '../../domain/entities/storage_info.dart';
import '../../domain/repositories/device_info_repository.dart';
import '../datasources/device_info_local_data_source.dart';

class DeviceInfoRepositoryImpl implements DeviceInfoRepository {
  final DeviceInfoLocalDataSource localDataSource;

  DeviceInfoRepositoryImpl({required this.localDataSource});

  @override
  Future<(Failure?, HardwareInfo?)> getHardwareInfo() async {
    try {
      final info = await localDataSource.getHardwareInfo();
      return (null, info);
    } catch (e) {
      return (PlatformFailure(e.toString()), null);
    }
  }

  @override
  Future<(Failure?, StorageInfo?)> getStorageInfo() async {
    try {
      final storage = await localDataSource.getStorageInfo();
      return (null, storage);
    } catch (e) {
      return (PlatformFailure(e.toString()), null);
    }
  }

  @override
  Stream<BatteryInfo> streamBatteryInfo() {
    return localDataSource.streamBatteryInfo();
  }
}
