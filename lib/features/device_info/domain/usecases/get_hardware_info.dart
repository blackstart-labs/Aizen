import '../../../../core/error/failures.dart';
import '../entities/hardware_info.dart';
import '../repositories/device_info_repository.dart';

class GetHardwareInfo {
  final DeviceInfoRepository repository;

  const GetHardwareInfo(this.repository);

  Future<(Failure?, HardwareInfo?)> call() => repository.getHardwareInfo();
}
